import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:mishkat/core/errors/exceptions.dart';
import 'package:mishkat/core/utills/text_manager.dart';
import 'package:mishkat/features/app_update/data/datasources/app_update_remote_data_source.dart';
import 'package:url_launcher/url_launcher.dart';

// Reads the store link from Remote Config and opens external links.
abstract class SettingsRemoteDataSource {
  // Returns this platform's store link, or an empty string when it is not set.
  Future<String> getStoreUrl();

  // Opens the given link outside the app.
  Future<void> openExternal(String url);
}

// Firebase Remote Config and url_launcher implementation of SettingsRemoteDataSource.
class SettingsRemoteDataSourceImp implements SettingsRemoteDataSource {
  final FirebaseRemoteConfig _remoteConfig;

  // Creates the data source with the Remote Config instance.
  SettingsRemoteDataSourceImp(this._remoteConfig);

  // Returns this platform's store link, or an empty string when it is not set.
  @override
  Future<String> getStoreUrl() async {
    try {
      await _remoteConfig.fetchAndActivate();
    } catch (e) {
      debugPrint('Settings: fetch failed, using the last activated values: $e');
    }
    final isIos = defaultTargetPlatform == TargetPlatform.iOS;
    return _remoteConfig.getString(isIos ? AppUpdateConfigKeys.iosStoreUrl : AppUpdateConfigKeys.androidStoreUrl).trim();
  }

  // Opens the given link outside the app.
  @override
  Future<void> openExternal(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null || !await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw const ServerException(TextManager.linkOpenFailed);
    }
  }
}
