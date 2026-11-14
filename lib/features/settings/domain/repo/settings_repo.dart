import 'package:dartz/dartz.dart';
import 'package:mishkat/core/errors/failure.dart';

// Contract for reading preferences.
abstract class SettingsRepo {
  // Returns the saved mushaf font size.
  Future<Either<Failure, double>> getQuranFontSize();

  // Saves the mushaf font size.
  Future<Either<Failure, double>> saveQuranFontSize(double size);

  // Returns the installed app version.
  Future<Either<Failure, String>> getAppVersion();

  // Returns this platform's store link.
  Future<Either<Failure, String>> getStoreUrl();

  // Opens the app's review page on this platform's store.
  Future<Either<Failure, Unit>> rateApp();

  // Opens the given link, such as a social media page, outside the app.
  Future<Either<Failure, Unit>> openLink(String url);
}
