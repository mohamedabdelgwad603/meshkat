import 'package:dartz/dartz.dart';
import 'package:mishkat/core/errors/failure.dart';

// Contract for reading preferences.
abstract class SettingsRepo {
  // Returns the saved mushaf font size.
  Future<Either<Failure, double>> getQuranFontSize();

  // Saves the mushaf font size.
  Future<Either<Failure, double>> saveQuranFontSize(double size);
}
