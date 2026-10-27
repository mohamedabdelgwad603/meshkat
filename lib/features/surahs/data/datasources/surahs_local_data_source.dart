import 'package:mishkat/core/errors/exceptions.dart';
import 'package:mishkat/core/services/local_storage/cache_helper.dart';
import 'package:mishkat/core/utills/text_manager.dart';
import 'package:mishkat/features/surahs/data/models/juz_model.dart';
import 'package:mishkat/features/surahs/data/models/surah_model.dart';

// Reads and writes surah data on the device and provides the fixed juz table.
abstract class SurahsLocalDataSource {
  // Returns the cached surah list or throws a CacheException.
  List<SurahModel> getCachedSurahs();

  // Saves the surah list for offline use.
  Future<void> cacheSurahs(List<SurahModel> surahs);

  // Returns the thirty juz with their starting positions.
  List<JuzModel> getJuzList();
}

// SharedPreferences implementation of SurahsLocalDataSource.
class SurahsLocalDataSourceImp implements SurahsLocalDataSource {
  final CacheHelper _cache;

  // Creates the data source with the cache helper.
  SurahsLocalDataSourceImp(this._cache);

  // Start of each juz in the Madani mushaf as [surah, ayah].
  static const List<List<int>> _juzStarts = [
    [1, 1], [2, 142], [2, 253], [3, 93], [4, 24], [4, 148], [5, 82], [6, 111], [7, 88], [8, 41],
    [9, 93], [11, 6], [12, 53], [15, 1], [17, 1], [18, 75], [21, 1], [23, 1], [25, 21], [27, 56],
    [29, 46], [33, 31], [36, 28], [39, 32], [41, 47], [46, 1], [51, 31], [58, 1], [67, 1], [78, 1],
  ];

  // Returns the cached surah list or throws a CacheException.
  @override
  List<SurahModel> getCachedSurahs() {
    final json = _cache.readJson(CacheKeys.surahList);
    if (json == null) throw const CacheException(TextManager.errorCache);
    return (json as List<dynamic>).map((e) => SurahModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  // Saves the surah list for offline use.
  @override
  Future<void> cacheSurahs(List<SurahModel> surahs) =>
      _cache.saveJson(CacheKeys.surahList, surahs.map((e) => e.toJson()).toList());

  // Returns the thirty juz with their starting positions.
  @override
  List<JuzModel> getJuzList() => [
        for (var i = 0; i < _juzStarts.length; i++)
          JuzModel(number: i + 1, surahNumber: _juzStarts[i][0], ayahNumber: _juzStarts[i][1]),
      ];
}
