import 'package:dartz/dartz.dart';
import 'package:mishkat/core/errors/failure.dart';
import 'package:mishkat/features/tafsir/data/models/tafsir_edition_model.dart';
import 'package:mishkat/features/tafsir/data/models/tafsir_model.dart';
import 'package:mishkat/features/tafsir/data/requests_params/tafsir_params.dart';

// Contract for tafsir books and per-ayah tafsir text.
abstract class TafsirRepo {
  // Returns the Arabic tafsir books, best-known ones first.
  Future<Either<Failure, List<TafsirEditionModel>>> getEditions();

  // Returns the tafsir of one ayah.
  Future<Either<Failure, TafsirModel>> getTafsir(TafsirParams params);

  // Returns the identifier of the chosen tafsir book.
  String getSelectedEdition();

  // Saves the identifier of the chosen tafsir book.
  Future<void> saveSelectedEdition(String identifier);
}
