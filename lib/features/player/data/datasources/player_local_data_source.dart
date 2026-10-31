import 'dart:io';

import 'package:mishkat/core/api/end_points.dart';
import 'package:mishkat/core/errors/exceptions.dart';
import 'package:mishkat/core/services/local_storage/cache_helper.dart';
import 'package:mishkat/core/utills/text_manager.dart';
import 'package:mishkat/features/player/data/models/ayah_audio_model.dart';
import 'package:mishkat/features/player/data/models/reciter_model.dart';
import 'package:path_provider/path_provider.dart';

// Stores reciter choices, audio URL lists and downloaded audio files on the device.
abstract class PlayerLocalDataSource {
  // Returns the cached reciter list or throws a CacheException.
  List<ReciterModel> getCachedReciters();

  // Saves the reciter list.
  Future<void> cacheReciters(List<ReciterModel> reciters);

  // Returns the chosen reciter's identifier.
  String getSelectedReciter();

  // Saves the chosen reciter's identifier.
  Future<void> saveSelectedReciter(String identifier);

  // Returns the cached audio list of a surah or throws a CacheException.
  List<AyahAudioModel> getCachedSurahAudio(int surah, String reciter);

  // Saves the audio list of a surah.
  Future<void> cacheSurahAudio(int surah, String reciter, List<AyahAudioModel> ayahs);

  // Returns the local path where an ayah's audio is or will be stored.
  Future<String> audioFilePath(String reciter, int ayahNumber);

  // Returns the local path of an ayah's audio when it was downloaded.
  Future<String?> downloadedFile(String reciter, int ayahNumber);
}

// SharedPreferences and file-system implementation of PlayerLocalDataSource.
class PlayerLocalDataSourceImp implements PlayerLocalDataSource {
  final CacheHelper _cache;
  Directory? _audioRoot;

  // Creates the data source with the cache helper.
  PlayerLocalDataSourceImp(this._cache);

  // Returns the cached reciter list or throws a CacheException.
  @override
  List<ReciterModel> getCachedReciters() {
    final json = _cache.readJson(CacheKeys.reciters);
    if (json == null) throw const CacheException(TextManager.errorCache);
    return (json as List<dynamic>).map((e) => ReciterModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  // Saves the reciter list.
  @override
  Future<void> cacheReciters(List<ReciterModel> reciters) =>
      _cache.saveJson(CacheKeys.reciters, reciters.map((e) => e.toJson()).toList());

  // Returns the chosen reciter's identifier, mapping a removed "-2" copy to its original reciter.
  @override
  String getSelectedReciter() {
    final saved = _cache.readString(CacheKeys.reciter) ?? EndPoints.defaultReciter;
    return saved.endsWith('-2') ? saved.substring(0, saved.length - 2) : saved;
  }

  // Saves the chosen reciter's identifier.
  @override
  Future<void> saveSelectedReciter(String identifier) => _cache.saveString(CacheKeys.reciter, identifier);

  // Returns the cached audio list of a surah or throws a CacheException.
  @override
  List<AyahAudioModel> getCachedSurahAudio(int surah, String reciter) {
    final json = _cache.readJson(CacheKeys.surahAudio(surah, reciter));
    if (json == null) throw const CacheException(TextManager.errorCache);
    return (json as List<dynamic>).map((e) => AyahAudioModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  // Saves the audio list of a surah.
  @override
  Future<void> cacheSurahAudio(int surah, String reciter, List<AyahAudioModel> ayahs) =>
      _cache.saveJson(CacheKeys.surahAudio(surah, reciter), ayahs.map((e) => e.toJson()).toList());

  // Returns the local path where an ayah's audio is or will be stored.
  @override
  Future<String> audioFilePath(String reciter, int ayahNumber) async {
    final root = await _root();
    final dir = Directory('${root.path}/$reciter');
    if (!dir.existsSync()) await dir.create(recursive: true);
    return '${dir.path}/$ayahNumber.mp3';
  }

  // Returns the local path of an ayah's audio when it was downloaded.
  @override
  Future<String?> downloadedFile(String reciter, int ayahNumber) async {
    final path = await audioFilePath(reciter, ayahNumber);
    final file = File(path);
    return file.existsSync() && file.lengthSync() > 0 ? path : null;
  }

  // Returns the app's audio folder, creating it on first use.
  Future<Directory> _root() async {
    if (_audioRoot != null) return _audioRoot!;
    final docs = await getApplicationDocumentsDirectory();
    _audioRoot = Directory('${docs.path}/audio');
    return _audioRoot!;
  }
}
