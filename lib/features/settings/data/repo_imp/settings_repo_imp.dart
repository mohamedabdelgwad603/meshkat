import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:mishkat/core/api/end_points.dart';
import 'package:mishkat/core/errors/exceptions.dart';
import 'package:mishkat/core/errors/failure.dart';
import 'package:mishkat/core/errors/safe_execute.dart';
import 'package:mishkat/core/utills/text_manager.dart';
import 'package:mishkat/features/settings/data/datasources/settings_local_data_source.dart';
import 'package:mishkat/features/settings/data/datasources/settings_remote_data_source.dart';
import 'package:mishkat/features/settings/domain/repo/settings_repo.dart';

// Implementation of SettingsRepo backed by the device and Remote Config.
class SettingsRepoImp implements SettingsRepo {
  final SettingsLocalDataSource _local;
  final SettingsRemoteDataSource _remote;

  // Creates the repository with its data sources.
  SettingsRepoImp(this._local, this._remote);

  // Returns the saved mushaf font size.
  @override
  Future<Either<Failure, double>> getQuranFontSize() => safeExecute(request: () async => _local.getQuranFontSize());

  // Saves the mushaf font size.
  @override
  Future<Either<Failure, double>> saveQuranFontSize(double size) => safeExecute(request: () async {
        await _local.saveQuranFontSize(size);
        return size;
      });

  // Returns the installed app version.
  @override
  Future<Either<Failure, String>> getAppVersion() => safeExecute(request: _local.getAppVersion);

  // Returns this platform's store link.
  @override
  Future<Either<Failure, String>> getStoreUrl() => safeExecute(request: _requireStoreUrl);

  // Opens the app's review page on this platform's store.
  @override
  Future<Either<Failure, Unit>> rateApp() => safeExecute(request: () async {
        await _remote.openExternal(_reviewUrl(await _requireStoreUrl()));
        return unit;
      });

  // Opens a WhatsApp chat with the support team and the given message.
  @override
  Future<Either<Failure, Unit>> contactUs(String message) => safeExecute(request: () async {
        await _remote.openExternal(EndPoints.whatsappChat(EndPoints.supportWhatsapp, message));
        return unit;
      });

  // Returns the store link or throws when it is not configured.
  Future<String> _requireStoreUrl() async {
    final url = await _remote.getStoreUrl();
    if (url.isEmpty) throw const ServerException(TextManager.storeLinkUnavailable);
    return url;
  }

  // Turns an App Store link into its write-review page; Google Play links are returned as they are.
  String _reviewUrl(String storeUrl) {
    if (defaultTargetPlatform != TargetPlatform.iOS) return storeUrl;
    final uri = Uri.parse(storeUrl);
    return uri.replace(queryParameters: {...uri.queryParameters, 'action': 'write-review'}).toString();
  }
}
