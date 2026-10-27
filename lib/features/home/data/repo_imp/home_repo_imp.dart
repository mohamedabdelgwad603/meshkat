import 'package:dartz/dartz.dart';
import 'package:mishkat/core/errors/exceptions.dart';
import 'package:mishkat/core/errors/failure.dart';
import 'package:mishkat/core/errors/safe_execute.dart';
import 'package:mishkat/features/home/data/datasources/home_local_data_source.dart';
import 'package:mishkat/features/home/data/datasources/home_remote_data_source.dart';
import 'package:mishkat/features/home/data/models/daily_ayah_model.dart';
import 'package:mishkat/features/home/data/requests_params/daily_ayah_params.dart';
import 'package:mishkat/features/home/domain/repo/home_repo.dart';

// Cache-first implementation of HomeRepo.
class HomeRepoImp implements HomeRepo {
  final HomeRemoteDataSource _remote;
  final HomeLocalDataSource _local;

  // Creates the repository with its data sources.
  HomeRepoImp(this._remote, this._local);

  // Returns the ayah of the day.
  @override
  Future<Either<Failure, DailyAyahModel>> getDailyAyah(DailyAyahParams params) => safeExecute(request: () async {
        try {
          return _local.getCachedDailyAyah(params.dayIndex);
        } on CacheException {
          final ayah = await _remote.getDailyAyah(params);
          await _local.cacheDailyAyah(params.dayIndex, ayah);
          return ayah;
        }
      });
}
