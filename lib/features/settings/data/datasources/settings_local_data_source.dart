import 'package:mishkat/core/services/local_storage/cache_helper.dart';
import 'package:package_info_plus/package_info_plus.dart';

// Stores reading preferences on the device.
abstract class SettingsLocalDataSource {
  // Returns the saved mushaf font size, or the default.
  double getQuranFontSize();

  // Saves the mushaf font size.
  Future<void> saveQuranFontSize(double size);

  // Returns the installed app version.
  Future<String> getAppVersion();
}

// SharedPreferences implementation of SettingsLocalDataSource.
class SettingsLocalDataSourceImp implements SettingsLocalDataSource {
  final CacheHelper _cache;
  static const double defaultFontSize = 25;

  // Creates the data source with the cache helper.
  SettingsLocalDataSourceImp(this._cache);

  // Returns the saved mushaf font size, or the default.
  @override
  double getQuranFontSize() => _cache.readDouble(CacheKeys.quranFontSize) ?? defaultFontSize;

  // Saves the mushaf font size.
  @override
  Future<void> saveQuranFontSize(double size) => _cache.saveDouble(CacheKeys.quranFontSize, size);

  // Returns the installed app version.
  @override
  Future<String> getAppVersion() async => (await PackageInfo.fromPlatform()).version;
}
