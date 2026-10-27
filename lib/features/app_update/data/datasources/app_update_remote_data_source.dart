import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:mishkat/core/errors/exceptions.dart';
import 'package:mishkat/core/utills/text_manager.dart';
import 'package:mishkat/features/app_update/data/models/app_update_model.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

// Parameter names defined in Firebase Remote Config.
class AppUpdateConfigKeys {
  AppUpdateConfigKeys._();

  static const String androidLatestVersion = 'android_latest_version';
  static const String iosLatestVersion = 'ios_latest_version';
  static const String androidStoreUrl = 'android_store_url';
  static const String iosStoreUrl = 'ios_store_url';
  static const String forceUpdate = 'force_update';
}

// Reads the published version from Remote Config and opens the store page.
abstract class AppUpdateRemoteDataSource {
  // Returns the installed version against the latest one published for this platform.
  Future<AppUpdateModel> checkForUpdate();

  // Opens the given store link outside the app.
  Future<void> openStore(String url);
}

// Firebase Remote Config implementation of AppUpdateRemoteDataSource.
class AppUpdateRemoteDataSourceImp implements AppUpdateRemoteDataSource {
  final FirebaseRemoteConfig _remoteConfig;

  // Creates the data source with the Remote Config instance.
  AppUpdateRemoteDataSourceImp(this._remoteConfig);

  // Returns the installed version against the latest one published for this platform.
  @override
  Future<AppUpdateModel> checkForUpdate() async {
    await _remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(seconds: 10),
      minimumFetchInterval: kDebugMode ? Duration.zero : const Duration(hours: 1),
    ));
    await _remoteConfig.setDefaults(const {
      AppUpdateConfigKeys.androidLatestVersion: '',
      AppUpdateConfigKeys.iosLatestVersion: '',
      AppUpdateConfigKeys.androidStoreUrl: '',
      AppUpdateConfigKeys.iosStoreUrl: '',
      AppUpdateConfigKeys.forceUpdate: false,
    });
    try {
      await _remoteConfig.fetchAndActivate();
    } catch (e) {
      debugPrint('AppUpdate: fetch failed, using the last activated values: $e');
    }
    final info = await PackageInfo.fromPlatform();
    final isIos = defaultTargetPlatform == TargetPlatform.iOS;
    return AppUpdateModel.fromJson({
      'current_version': info.version,
      'latest_version': _remoteConfig.getString(
        isIos ? AppUpdateConfigKeys.iosLatestVersion : AppUpdateConfigKeys.androidLatestVersion,
      ),
      'store_url': _remoteConfig.getString(
        isIos ? AppUpdateConfigKeys.iosStoreUrl : AppUpdateConfigKeys.androidStoreUrl,
      ),
      'force_update': _remoteConfig.getBool(AppUpdateConfigKeys.forceUpdate),
    });
  }

  // Opens the given store link outside the app.
  @override
  Future<void> openStore(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null || !await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw const ServerException(TextManager.errorUnknown);
    }
  }
}
