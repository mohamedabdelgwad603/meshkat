import 'package:dartz/dartz.dart';
import 'package:mishkat/core/errors/failure.dart';
import 'package:mishkat/features/home/data/models/daily_ayah_model.dart';
import 'package:mishkat/features/home/data/requests_params/daily_ayah_params.dart';

// Contract for the home screen's content.
abstract class HomeRepo {
  // Returns the ayah of the day.
  Future<Either<Failure, DailyAyahModel>> getDailyAyah(DailyAyahParams params);
}
