import 'package:dartz/dartz.dart';
import 'package:mishkat/core/errors/exceptions.dart';
import 'package:mishkat/core/errors/failure.dart';
import 'package:mishkat/core/errors/safe_execute.dart';
import 'package:mishkat/core/utills/text_manager.dart';
import 'package:mishkat/features/mutashabihat/data/datasources/mutashabihat_local_data_source.dart';
import 'package:mishkat/features/mutashabihat/data/models/mutashabih_ayah_model.dart';
import 'package:mishkat/features/mutashabihat/data/models/mutashabih_browse_model.dart';
import 'package:mishkat/features/mutashabihat/data/models/mutashabih_phrase_details_model.dart';
import 'package:mishkat/features/mutashabihat/data/models/mutashabih_phrase_model.dart';
import 'package:mishkat/features/mutashabihat/data/models/mutashabih_phrase_summary_model.dart';
import 'package:mishkat/features/mutashabihat/data/requests_params/ayah_mutashabihat_params.dart';
import 'package:mishkat/features/mutashabihat/data/requests_params/mutashabih_phrase_params.dart';
import 'package:mishkat/features/mutashabihat/domain/repo/mutashabihat_repo.dart';
import 'package:mishkat/features/reader/data/datasources/mushaf_script_local_data_source.dart';
import 'package:mishkat/features/reader/data/models/mushaf_surah_model.dart';

// Joins the similar-phrase data with the bundled mushaf text and surah names.
class MutashabihatRepoImp implements MutashabihatRepo {
  final MutashabihatLocalDataSource _local;
  final MushafScriptLocalDataSource _mushaf;

  // Creates the repository with its data sources.
  MutashabihatRepoImp(this._local, this._mushaf);

  // Returns the "surah:ayah" keys of every ayah that has similar phrases.
  @override
  Future<Either<Failure, Set<String>>> getAyahKeys() =>
      safeExecute(request: () async => (await _local.getAyahIndex()).keys.toSet());

  // Returns an ayah with its similar phrases, ordered by where they start, and each phrase's other ayahs in mushaf order.
  @override
  Future<Either<Failure, MutashabihatResultModel>> getAyahMutashabihat(AyahMutashabihatParams params) =>
      safeExecute(request: () async {
        final phrasesById = await _local.getPhrases();
        final ids = (await _local.getAyahIndex())[params.key] ?? const <int>[];
        final surahs = {for (final s in (await _mushaf.getMushaf()).surahs) s.number: s};
        final phrases = [for (final id in ids) phrasesById[id]!]
          ..sort((a, b) => a.ayahs[params.key]!.first.$1.compareTo(b.ayahs[params.key]!.first.$1));
        final ayah = await _ayah(params.key, [for (final p in phrases) ...p.ayahs[params.key]!], surahs);
        return MutashabihatResultModel(
          ayah: ayah,
          phrases: [for (final phrase in phrases) await _details(phrase, params.key, surahs)],
        );
      });

  // Returns every phrase in mushaf order of its first ayah, with the surahs for filtering.
  @override
  Future<Either<Failure, MutashabihBrowseModel>> getAllPhrases() => safeExecute(request: () async {
        final phrases = await _local.getPhrases();
        final surahList = (await _mushaf.getMushaf()).surahs;
        final surahs = {for (final s in surahList) s.number: s};
        final summaries = [for (final phrase in phrases.values) _summary(phrase, surahs)]
          ..sort((a, b) => _compareKeys((a.firstSurah, a.firstAyah), (b.firstSurah, b.firstAyah)));
        return MutashabihBrowseModel(phrases: summaries, surahs: surahList);
      });

  // Returns one phrase with every ayah it appears in, in mushaf order.
  @override
  Future<Either<Failure, MutashabihPhraseDetailsModel>> getPhrase(MutashabihPhraseParams params) =>
      safeExecute(request: () async {
        final phrase = (await _local.getPhrases())[params.phraseId];
        if (phrase == null) throw const CacheException(TextManager.errorCache);
        final surahs = {for (final s in (await _mushaf.getMushaf()).surahs) s.number: s};
        return _details(phrase, '', surahs);
      });

  // Builds the browse entry of a phrase from its first ayah in mushaf order.
  MutashabihPhraseSummaryModel _summary(MutashabihPhraseModel phrase, Map<int, MushafSurahModel> surahs) {
    final positions = phrase.ayahs.keys.map(_parseKey).toList()..sort(_compareKeys);
    final first = positions.first;
    return MutashabihPhraseSummaryModel(
      id: phrase.id,
      text: phrase.text,
      ayahCount: phrase.ayahs.length,
      surahCount: phrase.surahCount,
      surahNumbers: positions.map((p) => p.$1).toSet(),
      firstSurah: first.$1,
      firstAyah: first.$2,
      firstSurahName: surahs[first.$1]?.shortName ?? '',
      firstSurahEnglishName: surahs[first.$1]?.englishName ?? '',
    );
  }

  // Splits a "surah:ayah" key into its numbers.
  (int, int) _parseKey(String key) {
    final parts = key.split(':');
    return (int.parse(parts[0]), int.parse(parts[1]));
  }

  // Orders two ayah positions as they appear in the mushaf.
  int _compareKeys((int, int) a, (int, int) b) => a.$1 != b.$1 ? a.$1.compareTo(b.$1) : a.$2.compareTo(b.$2);

  // Builds a phrase's details with every ayah it appears in except the opened one.
  Future<MutashabihPhraseDetailsModel> _details(
    MutashabihPhraseModel phrase,
    String openedKey,
    Map<int, MushafSurahModel> surahs,
  ) async {
    return MutashabihPhraseDetailsModel(
      text: phrase.text,
      ayahCount: phrase.ayahs.length,
      surahCount: phrase.surahCount,
      otherAyahs: [
        for (final key in (phrase.ayahs.keys.toList()..sort((a, b) => _compareKeys(_parseKey(a), _parseKey(b)))))
          if (key != openedKey) await _ayah(key, phrase.ayahs[key]!, surahs),
      ],
    );
  }

  // Builds one ayah with its words, surah names and the ranges to highlight.
  Future<MutashabihAyahModel> _ayah(String key, List<(int, int)> highlights, Map<int, MushafSurahModel> surahs) async {
    final parts = key.split(':');
    final surahNumber = int.parse(parts[0]);
    final ayahNumber = int.parse(parts[1]);
    final script = await _mushaf.getAyahScript(surahNumber, ayahNumber);
    final surah = surahs[surahNumber];
    return MutashabihAyahModel(
      surahNumber: surahNumber,
      ayahNumber: ayahNumber,
      surahName: surah?.shortName ?? '',
      surahEnglishName: surah?.englishName ?? '',
      words: script.text.trim().split(RegExp(r'\s+')),
      highlights: highlights,
    );
  }
}
