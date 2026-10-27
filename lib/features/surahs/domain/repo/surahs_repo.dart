import 'package:dartz/dartz.dart';
import 'package:mishkat/core/errors/failure.dart';
import 'package:mishkat/features/surahs/data/models/juz_model.dart';
import 'package:mishkat/features/surahs/data/models/surah_model.dart';

// Contract for reading the surah index and juz table.
abstract class SurahsRepo {
  // Returns all surahs, from the network when possible and from cache otherwise.
  Future<Either<Failure, List<SurahModel>>> getSurahs();

  // Returns one surah's metadata by its number.
  Future<Either<Failure, SurahModel>> getSurah(int number);

  // Returns the thirty juz with their starting positions.
  List<JuzModel> getJuzList();
}
