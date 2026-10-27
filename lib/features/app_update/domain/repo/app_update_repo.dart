import 'package:dartz/dartz.dart';
import 'package:mishkat/core/errors/failure.dart';
import 'package:mishkat/features/app_update/data/models/app_update_model.dart';

// Contract for checking app updates and opening the store.
abstract class AppUpdateRepo {
  // Returns the installed version against the latest published one.
  Future<Either<Failure, AppUpdateModel>> checkForUpdate();

  // Opens the given store link.
  Future<Either<Failure, Unit>> openStore(String url);
}
