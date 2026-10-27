import 'package:dartz/dartz.dart';
import 'package:mishkat/core/errors/failure.dart';
import 'package:mishkat/features/player/data/models/ayah_audio_model.dart';
import 'package:mishkat/features/player/data/models/reciter_model.dart';
import 'package:mishkat/features/player/data/requests_params/surah_audio_params.dart';

// Contract for reciters, surah recitations and offline audio.
abstract class PlayerRepo {
  // Returns the Arabic verse-by-verse reciters.
  Future<Either<Failure, List<ReciterModel>>> getReciters();

  // Returns the audio of every ayah of a surah for a reciter.
  Future<Either<Failure, List<AyahAudioModel>>> getSurahAudio(SurahAudioParams params);

  // Returns the chosen reciter's identifier.
  String getSelectedReciter();

  // Saves the chosen reciter's identifier.
  Future<void> saveSelectedReciter(String identifier);

  // Returns, for each ayah, its downloaded file path or null when it must stream.
  Future<Either<Failure, List<String?>>> getLocalFiles(String reciter, List<AyahAudioModel> ayahs);

  // Downloads every ayah that is not yet on the device and reports overall progress.
  Future<Either<Failure, Unit>> downloadSurah(
    String reciter,
    List<AyahAudioModel> ayahs, {
    required void Function(double progress) onProgress,
  });
}
