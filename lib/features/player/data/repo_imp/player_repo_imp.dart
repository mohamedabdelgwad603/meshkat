import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:mishkat/core/errors/exceptions.dart';
import 'package:mishkat/core/errors/failure.dart';
import 'package:mishkat/core/errors/safe_execute.dart';
import 'package:mishkat/features/player/data/datasources/player_local_data_source.dart';
import 'package:mishkat/features/player/data/datasources/player_remote_data_source.dart';
import 'package:mishkat/features/player/data/models/ayah_audio_model.dart';
import 'package:mishkat/features/player/data/models/reciter_model.dart';
import 'package:mishkat/features/player/data/requests_params/surah_audio_params.dart';
import 'package:mishkat/features/player/domain/repo/player_repo.dart';

// Implementation of PlayerRepo with cached URL lists and on-device audio files.
class PlayerRepoImp implements PlayerRepo {
  final PlayerRemoteDataSource _remote;
  final PlayerLocalDataSource _local;

  // Creates the repository with its data sources.
  PlayerRepoImp(this._remote, this._local);

  // Returns the Arabic verse-by-verse reciters.
  @override
  Future<Either<Failure, List<ReciterModel>>> getReciters() => safeExecute(request: () async {
        try {
          return _local.getCachedReciters();
        } on CacheException {
          final reciters = await _remote.getReciters();
          await _local.cacheReciters(reciters);
          return reciters;
        }
      });

  // Returns the audio of every ayah of a surah for a reciter.
  @override
  Future<Either<Failure, List<AyahAudioModel>>> getSurahAudio(SurahAudioParams params) =>
      safeExecute(request: () async {
        try {
          return _local.getCachedSurahAudio(params.surahNumber, params.reciter);
        } on CacheException {
          final ayahs = await _remote.getSurahAudio(params);
          await _local.cacheSurahAudio(params.surahNumber, params.reciter, ayahs);
          return ayahs;
        }
      });

  // Returns the chosen reciter's identifier.
  @override
  String getSelectedReciter() => _local.getSelectedReciter();

  // Saves the chosen reciter's identifier.
  @override
  Future<void> saveSelectedReciter(String identifier) => _local.saveSelectedReciter(identifier);

  // Returns, for each ayah, its downloaded file path or null when it must stream.
  @override
  Future<Either<Failure, List<String?>>> getLocalFiles(String reciter, List<AyahAudioModel> ayahs) =>
      safeExecute(request: () => Future.wait(ayahs.map((a) => _local.downloadedFile(reciter, a.number))));

  // Downloads every ayah that is not yet on the device and reports overall progress.
  @override
  Future<Either<Failure, Unit>> downloadSurah(
    String reciter,
    List<AyahAudioModel> ayahs, {
    required void Function(double progress) onProgress,
  }) =>
      safeExecute(request: () async {
        for (var i = 0; i < ayahs.length; i++) {
          final ayah = ayahs[i];
          if (await _local.downloadedFile(reciter, ayah.number) == null) {
            final path = await _local.audioFilePath(reciter, ayah.number);
            final partial = '$path.part';
            await _remote.downloadAudio(
              ayah.audioUrl,
              partial,
              onProgress: (p) => onProgress((i + p) / ayahs.length),
            );
            await File(partial).rename(path);
          }
          onProgress((i + 1) / ayahs.length);
        }
        return unit;
      });
}
