import 'package:mishkat/core/api/end_points.dart';
import 'package:mishkat/core/errors/exceptions.dart';
import 'package:mishkat/core/services/local_storage/cache_helper.dart';
import 'package:mishkat/core/utills/text_manager.dart';
import 'package:mishkat/features/tafsir/data/models/tafsir_edition_model.dart';

// Stores the tafsir book list and the user's chosen book.
abstract class TafsirLocalDataSource {
  // Returns the cached tafsir books or throws a CacheException.
  List<TafsirEditionModel> getCachedEditions();

  // Saves the tafsir book list.
  Future<void> cacheEditions(List<TafsirEditionModel> editions);

  // Returns the identifier of the chosen tafsir book.
  String getSelectedEdition();

  // Saves the identifier of the chosen tafsir book.
  Future<void> saveSelectedEdition(String identifier);
}

// SharedPreferences implementation of TafsirLocalDataSource.
class TafsirLocalDataSourceImp implements TafsirLocalDataSource {
  final CacheHelper _cache;

  // Creates the data source with the cache helper.
  TafsirLocalDataSourceImp(this._cache);

  // Returns the cached tafsir books or throws a CacheException.
  @override
  List<TafsirEditionModel> getCachedEditions() {
    final json = _cache.readJson(CacheKeys.tafsirEditions);
    if (json == null) throw const CacheException(TextManager.errorCache);
    return (json as List<dynamic>).map((e) => TafsirEditionModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  // Saves the tafsir book list.
  @override
  Future<void> cacheEditions(List<TafsirEditionModel> editions) =>
      _cache.saveJson(CacheKeys.tafsirEditions, editions.map((e) => e.toJson()).toList());

  // Returns the identifier of the chosen tafsir book.
  @override
  String getSelectedEdition() => _cache.readString(CacheKeys.tafsirEdition) ?? EndPoints.defaultTafsir;

  // Saves the identifier of the chosen tafsir book.
  @override
  Future<void> saveSelectedEdition(String identifier) => _cache.saveString(CacheKeys.tafsirEdition, identifier);
}
