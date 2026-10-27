import 'package:mishkat/core/errors/exceptions.dart';
import 'package:mishkat/core/services/local_storage/cache_helper.dart';
import 'package:mishkat/core/utills/text_manager.dart';
import 'package:mishkat/features/reader/data/models/surah_text_model.dart';

// Stores surah text on the device so reading works offline.
abstract class ReaderLocalDataSource {
  // Returns a cached surah or throws a CacheException.
  SurahTextModel getCachedSurah(int number);

  // Saves a surah for offline reading.
  Future<void> cacheSurah(SurahTextModel surah);
}

// SharedPreferences implementation of ReaderLocalDataSource.
class ReaderLocalDataSourceImp implements ReaderLocalDataSource {
  final CacheHelper _cache;

  // Creates the data source with the cache helper.
  ReaderLocalDataSourceImp(this._cache);

  // Returns a cached surah or throws a CacheException.
  @override
  SurahTextModel getCachedSurah(int number) {
    final json = _cache.readJson(CacheKeys.surahText(number));
    if (json == null) throw const CacheException(TextManager.errorCache);
    return SurahTextModel.fromCache(json as Map<String, dynamic>);
  }

  // Saves a surah for offline reading.
  @override
  Future<void> cacheSurah(SurahTextModel surah) => _cache.saveJson(CacheKeys.surahText(surah.number), surah.toJson());
}
