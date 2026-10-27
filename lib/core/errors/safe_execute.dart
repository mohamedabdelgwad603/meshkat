import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:mishkat/core/errors/exceptions.dart';
import 'package:mishkat/core/errors/failure.dart';
import 'package:mishkat/core/utills/text_manager.dart';

// Runs a data request and wraps its outcome in an Either of Failure or the result.
Future<Either<Failure, T>> safeExecute<T>({required Future<T> Function() request}) async {
  try {
    return Right(await request());
  } on ServerException catch (e) {
    return Left(ServerFailure(e.message));
  } on CacheException catch (e) {
    return Left(CacheFailure(e.message));
  } catch (e, s) {
    debugPrint('safeExecute: $e\n$s');
    return const Left(ServerFailure(TextManager.errorUnknown));
  }
}
