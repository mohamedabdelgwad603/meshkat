import 'package:mishkat/core/errors/exceptions.dart';
import 'package:mishkat/core/services/local_storage/cache_helper.dart';
import 'package:mishkat/core/utills/text_manager.dart';
import 'package:mishkat/features/home/data/models/daily_ayah_model.dart';

// Keeps the day's ayah on the device so it shows instantly and offline.
abstract class HomeLocalDataSource {
  // Returns the cached ayah for the day or throws a CacheException.
  DailyAyahModel getCachedDailyAyah(int dayIndex);

  // Saves the ayah for the day.
  Future<void> cacheDailyAyah(int dayIndex, DailyAyahModel ayah);
}

// SharedPreferences implementation of HomeLocalDataSource.
class HomeLocalDataSourceImp implements HomeLocalDataSource {
  final CacheHelper _cache;

  // Creates the data source with the cache helper.
  HomeLocalDataSourceImp(this._cache);

  // Returns the cached ayah for the day or throws a CacheException.
  @override
  DailyAyahModel getCachedDailyAyah(int dayIndex) {
    final json = _cache.readJson(CacheKeys.dailyAyah(dayIndex));
    if (json == null) throw const CacheException(TextManager.errorCache);
    return DailyAyahModel.fromCache(json as Map<String, dynamic>);
  }

  // Saves the ayah for the day and drops the previous day's entry.
  @override
  Future<void> cacheDailyAyah(int dayIndex, DailyAyahModel ayah) async {
    await _cache.remove(CacheKeys.dailyAyah(dayIndex - 1));
    await _cache.saveJson(CacheKeys.dailyAyah(dayIndex), ayah.toJson());
  }
}
