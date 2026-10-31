import 'package:dartz/dartz.dart';
import 'package:mishkat/core/errors/failure.dart';
import 'package:mishkat/core/errors/safe_execute.dart';
import 'package:mishkat/features/settings/data/datasources/settings_local_data_source.dart';
import 'package:mishkat/features/settings/domain/repo/settings_repo.dart';

// Local implementation of SettingsRepo.
class SettingsRepoImp implements SettingsRepo {
  final SettingsLocalDataSource _local;

  // Creates the repository with its local data source.
  SettingsRepoImp(this._local);

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
}
