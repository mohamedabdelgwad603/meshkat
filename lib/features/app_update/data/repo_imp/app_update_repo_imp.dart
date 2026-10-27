import 'package:dartz/dartz.dart';
import 'package:mishkat/core/errors/failure.dart';
import 'package:mishkat/core/errors/safe_execute.dart';
import 'package:mishkat/features/app_update/data/datasources/app_update_remote_data_source.dart';
import 'package:mishkat/features/app_update/data/models/app_update_model.dart';
import 'package:mishkat/features/app_update/domain/repo/app_update_repo.dart';

// Remote Config implementation of AppUpdateRepo.
class AppUpdateRepoImp implements AppUpdateRepo {
  final AppUpdateRemoteDataSource _remote;

  // Creates the repository with its remote data source.
  AppUpdateRepoImp(this._remote);

  // Returns the installed version against the latest published one.
  @override
  Future<Either<Failure, AppUpdateModel>> checkForUpdate() => safeExecute(request: () => _remote.checkForUpdate());

  // Opens the given store link.
  @override
  Future<Either<Failure, Unit>> openStore(String url) => safeExecute(request: () async {
        await _remote.openStore(url);
        return unit;
      });
}
