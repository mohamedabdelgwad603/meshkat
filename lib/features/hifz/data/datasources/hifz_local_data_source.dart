import 'dart:async';

import 'package:mishkat/core/services/local_storage/cache_helper.dart';
import 'package:mishkat/features/hifz/data/models/hifz_settings_model.dart';

// Stores memorization settings and which ayahs the user marked as memorized.
abstract class HifzLocalDataSource {
  // Returns the last used session settings, or the defaults.
  HifzSettingsModel getSettings();

  // Saves the session settings.
  Future<void> saveSettings(HifzSettingsModel settings);

  // Returns the ayah numbers marked as memorized in a surah.
  Set<int> getMemorized(int surahNumber);

  // Marks or unmarks an ayah as memorized.
  Future<void> setMemorized(int surahNumber, int ayahNumber, bool memorized);

  // Emits the surah number whenever its memorized ayahs change.
  Stream<int> get memorizedChanges;
}

// SharedPreferences implementation of HifzLocalDataSource.
class HifzLocalDataSourceImp implements HifzLocalDataSource {
  final CacheHelper _cache;
  final StreamController<int> _changes = StreamController<int>.broadcast();

  // Creates the data source with the cache helper.
  HifzLocalDataSourceImp(this._cache);

  // Emits the surah number whenever its memorized ayahs change.
  @override
  Stream<int> get memorizedChanges => _changes.stream;

  // Returns the last used session settings, or the defaults.
  @override
  HifzSettingsModel getSettings() {
    final json = _cache.readJson(CacheKeys.hifzSettings);
    return json is Map<String, dynamic> ? HifzSettingsModel.fromJson(json) : const HifzSettingsModel();
  }

  // Saves the session settings.
  @override
  Future<void> saveSettings(HifzSettingsModel settings) => _cache.saveJson(CacheKeys.hifzSettings, settings.toJson());

  // Returns the ayah numbers marked as memorized in a surah.
  @override
  Set<int> getMemorized(int surahNumber) {
    final ayahs = _readAll()['$surahNumber'];
    return ayahs is List ? ayahs.whereType<int>().toSet() : <int>{};
  }

  // Marks or unmarks an ayah as memorized.
  @override
  Future<void> setMemorized(int surahNumber, int ayahNumber, bool memorized) async {
    final all = _readAll();
    final ayahs = getMemorized(surahNumber);
    memorized ? ayahs.add(ayahNumber) : ayahs.remove(ayahNumber);
    if (ayahs.isEmpty) {
      all.remove('$surahNumber');
    } else {
      all['$surahNumber'] = (ayahs.toList()..sort());
    }
    await _cache.saveJson(CacheKeys.hifzMemorized, all);
    _changes.add(surahNumber);
  }

  // Reads the whole surah-to-ayahs map of memorized ayahs.
  Map<String, dynamic> _readAll() {
    final json = _cache.readJson(CacheKeys.hifzMemorized);
    return json is Map<String, dynamic> ? Map<String, dynamic>.of(json) : <String, dynamic>{};
  }
}
