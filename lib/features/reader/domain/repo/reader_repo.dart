import 'package:dartz/dartz.dart';
import 'package:mishkat/core/errors/failure.dart';
import 'package:mishkat/features/reader/data/models/mushaf_model.dart';
import 'package:mishkat/features/reader/data/models/surah_text_model.dart';
import 'package:mishkat/features/reader/data/requests_params/surah_text_params.dart';

// Contract for reading surah text and the laid-out mushaf.
abstract class ReaderRepo {
  // Returns a surah's text from cache, or from the network and caches it.
  Future<Either<Failure, SurahTextModel>> getSurahText(SurahTextParams params);

  // Returns the whole mushaf laid out page by page.
  Future<Either<Failure, MushafModel>> getMushaf();
}
