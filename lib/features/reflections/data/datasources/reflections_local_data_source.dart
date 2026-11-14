import 'package:mishkat/core/services/local_storage/cache_helper.dart';
import 'package:mishkat/features/reflections/data/models/reflection_model.dart';

// Stores the reflection notebook on the device.
abstract class ReflectionsLocalDataSource {
  // Returns all saved reflections, most recently edited first.
  List<ReflectionModel> getReflections();

  // Replaces the saved reflection list.
  Future<void> saveReflections(List<ReflectionModel> reflections);
}

// SharedPreferences implementation of ReflectionsLocalDataSource.
class ReflectionsLocalDataSourceImp implements ReflectionsLocalDataSource {
  final CacheHelper _cache;

  // Creates the data source with the cache helper.
  ReflectionsLocalDataSourceImp(this._cache);

  // Returns all saved reflections, most recently edited first.
  @override
  List<ReflectionModel> getReflections() {
    final json = _cache.readJson(CacheKeys.reflections);
    if (json == null) return [];
    return (json as List<dynamic>).map((e) => ReflectionModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  // Replaces the saved reflection list.
  @override
  Future<void> saveReflections(List<ReflectionModel> reflections) =>
      _cache.saveJson(CacheKeys.reflections, reflections.map((e) => e.toJson()).toList());
}
