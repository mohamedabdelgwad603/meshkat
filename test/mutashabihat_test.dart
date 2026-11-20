import 'package:flutter_test/flutter_test.dart';
import 'package:mishkat/features/hifz/data/models/hifz_ayah_model.dart';
import 'package:mishkat/features/mutashabihat/data/datasources/mutashabihat_local_data_source.dart';
import 'package:mishkat/features/mutashabihat/data/models/mutashabih_phrase_details_model.dart';
import 'package:mishkat/features/mutashabihat/data/repo_imp/mutashabihat_repo_imp.dart';
import 'package:mishkat/features/mutashabihat/data/requests_params/ayah_mutashabihat_params.dart';
import 'package:mishkat/features/mutashabihat/data/requests_params/mutashabih_phrase_params.dart';
import 'package:mishkat/features/mutashabihat/presentation/cubit/mutashabihat_browse_cubit.dart';
import 'package:mishkat/features/mutashabihat/presentation/cubit/mutashabihat_browse_state.dart';
import 'package:mishkat/features/reader/data/datasources/mushaf_script_local_data_source.dart';

// Checks the bundled mutashabihat data against the mushaf text it is shown with.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final local = MutashabihatLocalDataSourceImp();
  final mushaf = MushafScriptLocalDataSourceImp();
  final repo = MutashabihatRepoImp(local, mushaf);

  test('loads every phrase and ayah of the QUL dataset', () async {
    expect((await local.getPhrases()).length, 814);
    expect((await local.getAyahIndex()).length, 2232);
  });

  test('every highlighted range lies inside its ayah and never covers a quarter or prostration mark', () async {
    for (final phrase in (await local.getPhrases()).values) {
      for (final entry in phrase.ayahs.entries) {
        final parts = entry.key.split(':');
        final words =
            (await mushaf.getAyahScript(int.parse(parts[0]), int.parse(parts[1]))).text.trim().split(RegExp(r'\s+'));
        for (final (from, to) in entry.value) {
          expect(from >= 1 && from <= to && to <= words.length, isTrue, reason: '${phrase.id} ${entry.key}');
          expect(words.sublist(from - 1, to).any((w) => w == '۞' || w == '۩'), isFalse);
        }
      }
    }
  });

  test('Al-Baqarah 2:112 shows its phrases from the downloaded dataset with the other ayahs highlighted', () async {
    final result = await repo.getAyahMutashabihat(const AyahMutashabihatParams(surahNumber: 2, ayahNumber: 112));
    final data = result.getOrElse(() => throw StateError('failed'));
    expect(data.ayah.surahNumber, 2);
    expect(data.ayah.surahName, isNotEmpty);
    expect(data.phrases.map((p) => p.ayahCount).toList()..sort(), [2, 12]);
    for (final MutashabihPhraseDetailsModel phrase in data.phrases) {
      expect(phrase.otherAyahs.length, phrase.ayahCount - 1);
      expect(phrase.otherAyahs.any((a) => a.surahNumber == 2 && a.ayahNumber == 112), isFalse);
      for (final ayah in phrase.otherAyahs) {
        expect(ayah.highlights, isNotEmpty);
        expect(ayah.highlights.every((r) => r.$2 <= ayah.words.length), isTrue);
      }
    }
  });

  test('an ayah without similar phrases returns an empty list', () async {
    final keys = (await repo.getAyahKeys()).getOrElse(() => {});
    final ayah = [for (var i = 1; i <= 286; i++) '2:$i'].firstWhere((k) => !keys.contains(k));
    final number = int.parse(ayah.split(':')[1]);
    final result = await repo.getAyahMutashabihat(AyahMutashabihatParams(surahNumber: 2, ayahNumber: number));
    expect(result.getOrElse(() => throw StateError('failed')).phrases, isEmpty);
  });

  test('memorization words skip the quarter mark at the start of an ayah', () async {
    final text = (await mushaf.getAyahScript(2, 26)).text;
    final ayah = HifzAyahModel(
      surahNumber: 2,
      ayahNumber: 26,
      globalNumber: 33,
      text: text,
      audioSource: '',
      isLocalFile: false,
    );
    expect(text.startsWith('۞'), isTrue);
    expect(ayah.words.first, text.trim().split(RegExp(r'\s+'))[1]);
    expect(ayah.words.contains('۞'), isFalse);
  });

  test('browse lists every phrase in mushaf order and a phrase opens with all its ayahs', () async {
    final browse = (await repo.getAllPhrases()).getOrElse(() => throw StateError('failed'));
    expect(browse.phrases.length, 814);
    expect(browse.surahs.length, 114);
    for (var i = 1; i < browse.phrases.length; i++) {
      final a = browse.phrases[i - 1], b = browse.phrases[i];
      expect(a.firstSurah < b.firstSurah || (a.firstSurah == b.firstSurah && a.firstAyah <= b.firstAyah), isTrue);
    }
    final first = browse.phrases.first;
    final phrase =
        (await repo.getPhrase(MutashabihPhraseParams(phraseId: first.id))).getOrElse(() => throw StateError('failed'));
    expect(phrase.otherAyahs.length, first.ayahCount);
    expect(phrase.otherAyahs.first.surahNumber, first.firstSurah);
    expect(phrase.otherAyahs.first.ayahNumber, first.firstAyah);
  });

  test('browse search ignores diacritics and the surah filter keeps only phrases in that surah', () async {
    final cubit = MutashabihatBrowseCubit(repo);
    await cubit.load();
    MutashabihBrowseData data() => (cubit.state as MutashabihatBrowseSuccess).data;
    cubit.search('دون الله');
    expect(data().visible, isNotEmpty);
    expect(
      data().visible.every((p) => normalizeArabic(p.text).contains('دون') && normalizeArabic(p.text).contains('الله')),
      isTrue,
    );
    expect(data().visible.any((p) => normalizeArabic(p.text) == 'من دون الله'), isTrue);
    cubit.search('');
    final mulk = data().surahs.firstWhere((s) => s.number == 67);
    cubit.filterBySurah(mulk);
    expect(data().visible, isNotEmpty);
    expect(data().visible.every((p) => p.surahNumbers.contains(67)), isTrue);
    cubit.setSort(MutashabihSort.mostRepeated);
    final counts = data().visible.map((p) => p.ayahCount).toList();
    expect(counts, [...counts]..sort((a, b) => b.compareTo(a)));
    cubit.filterBySurah(null);
    expect(data().visible.length, 814);
    await cubit.close();
  });
}
