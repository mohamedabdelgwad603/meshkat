import 'package:dartz/dartz.dart';
import 'package:mishkat/core/errors/failure.dart';
import 'package:mishkat/features/hifz/data/models/hifz_session_model.dart';
import 'package:mishkat/features/hifz/data/models/hifz_settings_model.dart';
import 'package:mishkat/features/hifz/data/requests_params/hifz_session_params.dart';
import 'package:mishkat/features/reader/data/models/mushaf_surah_model.dart';

// Contract for memorization sessions, their settings and the user's progress.
abstract class HifzRepo {
  // Returns the 114 surahs with their ayah counts.
  Future<Either<Failure, List<MushafSurahModel>>> getSurahs();

  // Returns the text and audio of the ayahs in a range for the chosen reciter.
  Future<Either<Failure, HifzSessionModel>> getSession(HifzSessionParams params);

  // Returns the text of the ayahs in a range without audio, for self-testing offline.
  Future<Either<Failure, HifzSessionModel>> getTestAyahs(HifzSessionParams params);

  // Returns the last used session settings.
  HifzSettingsModel getSettings();

  // Saves the session settings.
  Future<Either<Failure, HifzSettingsModel>> saveSettings(HifzSettingsModel settings);

  // Returns the ayah numbers marked as memorized in a surah.
  Future<Either<Failure, Set<int>>> getMemorized(int surahNumber);

  // Marks or unmarks an ayah as memorized and returns the surah's new set.
  Future<Either<Failure, Set<int>>> setMemorized(int surahNumber, int ayahNumber, bool memorized);

  // Emits the surah number whenever its memorized ayahs change.
  Stream<int> get memorizedChanges;
}
