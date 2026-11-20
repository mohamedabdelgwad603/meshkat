import 'package:dartz/dartz.dart';
import 'package:mishkat/core/errors/failure.dart';
import 'package:mishkat/features/mutashabihat/data/models/mutashabih_phrase_details_model.dart';
import 'package:mishkat/features/mutashabihat/data/models/mutashabih_browse_model.dart';
import 'package:mishkat/features/mutashabihat/data/requests_params/ayah_mutashabihat_params.dart';
import 'package:mishkat/features/mutashabihat/data/requests_params/mutashabih_phrase_params.dart';

// Contract for the Quran's similar phrases.
abstract class MutashabihatRepo {
  // Returns the "surah:ayah" keys of every ayah that has similar phrases.
  Future<Either<Failure, Set<String>>> getAyahKeys();

  // Returns an ayah with its similar phrases and the other ayahs each phrase appears in.
  Future<Either<Failure, MutashabihatResultModel>> getAyahMutashabihat(AyahMutashabihatParams params);

  // Returns every phrase in mushaf order of its first ayah, with the surahs for filtering.
  Future<Either<Failure, MutashabihBrowseModel>> getAllPhrases();

  // Returns one phrase with every ayah it appears in.
  Future<Either<Failure, MutashabihPhraseDetailsModel>> getPhrase(MutashabihPhraseParams params);
}
