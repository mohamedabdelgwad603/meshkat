import 'package:dartz/dartz.dart';
import 'package:mishkat/core/errors/exceptions.dart';
import 'package:mishkat/core/errors/failure.dart';
import 'package:mishkat/core/errors/safe_execute.dart';
import 'package:mishkat/core/utills/text_manager.dart';
import 'package:mishkat/features/hifz/data/datasources/hifz_local_data_source.dart';
import 'package:mishkat/features/hifz/data/models/hifz_session_model.dart';
import 'package:mishkat/features/hifz/data/models/hifz_settings_model.dart';
import 'package:mishkat/features/hifz/data/requests_params/hifz_session_params.dart';
import 'package:mishkat/features/hifz/domain/repo/hifz_repo.dart';
import 'package:mishkat/features/player/data/models/reciter_model.dart';
import 'package:mishkat/features/player/data/requests_params/surah_audio_params.dart';
import 'package:mishkat/features/player/domain/repo/player_repo.dart';
import 'package:mishkat/features/reader/data/datasources/mushaf_script_local_data_source.dart';
import 'package:mishkat/features/reader/data/models/mushaf_surah_model.dart';

// Builds memorization sessions from the bundled mushaf text and the recitation audio.
class HifzRepoImp implements HifzRepo {
  final HifzLocalDataSource _local;
  final MushafScriptLocalDataSource _mushaf;
  final PlayerRepo _player;

  // Creates the repository with its data sources and the recitation repository.
  HifzRepoImp(this._local, this._mushaf, this._player);

  // Returns the 114 surahs with their ayah counts.
  @override
  Future<Either<Failure, List<MushafSurahModel>>> getSurahs() =>
      safeExecute(request: () async => (await _mushaf.getMushaf()).surahs);

  // Returns the text and audio of the ayahs in a range for the chosen reciter, preferring downloaded files.
  @override
  Future<Either<Failure, HifzSessionModel>> getSession(HifzSessionParams params) => safeExecute(request: () async {
        final reciter = await _selectedReciter();
        final audioResult = await _player.getSurahAudio(
          SurahAudioParams(surahNumber: params.surahNumber, reciter: reciter.identifier),
        );
        final allAudio = audioResult.fold((failure) => throw ServerException(failure.message), (list) => list);
        final range = _range(params, allAudio.length);
        final audio = allAudio.sublist(range.$1 - 1, range.$2);
        final localFiles = (await _player.getLocalFiles(reciter.identifier, audio))
            .getOrElse(() => List<String?>.filled(audio.length, null));
        final texts = await _mushaf.getSurahScript(params.surahNumber);
        return HifzSessionModel.fromJson({
          ...await _surahNames(params.surahNumber),
          'reciterName': reciter.name,
          'ayahs': [
            for (var i = 0; i < audio.length; i++)
              {
                'surahNumber': params.surahNumber,
                'ayahNumber': audio[i].numberInSurah,
                'globalNumber': audio[i].number,
                'text': texts[audio[i].numberInSurah - 1].text,
                'audioSource': localFiles[i] ?? audio[i].audioUrl,
                'isLocalFile': localFiles[i] != null,
              },
          ],
        });
      });

  // Returns the text of the ayahs in a range without audio, for self-testing offline.
  @override
  Future<Either<Failure, HifzSessionModel>> getTestAyahs(HifzSessionParams params) => safeExecute(request: () async {
        final texts = await _mushaf.getSurahScript(params.surahNumber);
        final range = _range(params, texts.length);
        return HifzSessionModel.fromJson({
          ...await _surahNames(params.surahNumber),
          'reciterName': '',
          'ayahs': [
            for (var ayah = range.$1; ayah <= range.$2; ayah++)
              {
                'surahNumber': params.surahNumber,
                'ayahNumber': ayah,
                'globalNumber': 0,
                'text': texts[ayah - 1].text,
                'audioSource': '',
                'isLocalFile': false,
              },
          ],
        });
      });

  // Returns the last used session settings.
  @override
  HifzSettingsModel getSettings() => _local.getSettings();

  // Saves the session settings.
  @override
  Future<Either<Failure, HifzSettingsModel>> saveSettings(HifzSettingsModel settings) => safeExecute(request: () async {
        await _local.saveSettings(settings);
        return settings;
      });

  // Returns the ayah numbers marked as memorized in a surah.
  @override
  Future<Either<Failure, Set<int>>> getMemorized(int surahNumber) =>
      safeExecute(request: () async => _local.getMemorized(surahNumber));

  // Marks or unmarks an ayah as memorized and returns the surah's new set.
  @override
  Future<Either<Failure, Set<int>>> setMemorized(int surahNumber, int ayahNumber, bool memorized) =>
      safeExecute(request: () async {
        await _local.setMemorized(surahNumber, ayahNumber, memorized);
        return _local.getMemorized(surahNumber);
      });

  // Emits the surah number whenever its memorized ayahs change.
  @override
  Stream<int> get memorizedChanges => _local.memorizedChanges;

  // Returns the chosen reciter, falling back to its identifier when the list is unavailable.
  Future<ReciterModel> _selectedReciter() async {
    final id = _player.getSelectedReciter();
    final reciters = (await _player.getReciters()).getOrElse(() => const <ReciterModel>[]);
    return reciters.firstWhere(
      (r) => r.identifier == id,
      orElse: () => ReciterModel(identifier: id, name: '', englishName: ''),
    );
  }

  // Clamps the requested range to the surah and returns it as (from, to), throwing when it is empty.
  (int, int) _range(HifzSessionParams params, int ayahCount) {
    if (ayahCount == 0) throw const CacheException(TextManager.errorCache);
    final from = params.fromAyah.clamp(1, ayahCount).toInt();
    final to = params.toAyah.clamp(from, ayahCount).toInt();
    return (from, to);
  }

  // Returns the Arabic and English names of a surah for display.
  Future<Map<String, dynamic>> _surahNames(int surahNumber) async {
    final surah = (await _mushaf.getMushaf()).surahs.firstWhere((s) => s.number == surahNumber);
    return {'surahName': surah.shortName, 'surahEnglishName': surah.englishName};
  }
}
