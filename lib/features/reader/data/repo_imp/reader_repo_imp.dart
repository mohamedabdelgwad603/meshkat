import 'package:dartz/dartz.dart';
import 'package:mishkat/core/errors/exceptions.dart';
import 'package:mishkat/core/errors/failure.dart';
import 'package:mishkat/core/errors/safe_execute.dart';
import 'package:mishkat/features/reader/data/datasources/mushaf_script_local_data_source.dart';
import 'package:mishkat/features/reader/data/datasources/reader_local_data_source.dart';
import 'package:mishkat/features/reader/data/datasources/reader_remote_data_source.dart';
import 'package:mishkat/features/reader/data/models/mushaf_model.dart';
import 'package:mishkat/features/reader/data/models/surah_text_model.dart';
import 'package:mishkat/features/reader/data/requests_params/surah_text_params.dart';
import 'package:mishkat/features/reader/domain/repo/reader_repo.dart';

// Cache-first implementation of ReaderRepo; Quran text never changes once downloaded.
class ReaderRepoImp implements ReaderRepo {
  final ReaderRemoteDataSource _remote;
  final ReaderLocalDataSource _local;
  final MushafScriptLocalDataSource _mushaf;

  // Creates the repository with its data sources.
  ReaderRepoImp(this._remote, this._local, this._mushaf);

  // Returns a surah from cache, or from the network and caches it, with the printed mushaf text.
  @override
  Future<Either<Failure, SurahTextModel>> getSurahText(SurahTextParams params) => safeExecute(request: () async {
        final surah = await _loadSurah(params);
        return surah.withMushaf(await _mushaf.getSurahScript(params.surahNumber));
      });

  // Returns the whole mushaf laid out page by page.
  @override
  Future<Either<Failure, MushafModel>> getMushaf() => safeExecute(request: () => _mushaf.getMushaf());

  // Returns the surah from cache, or from the network and caches it.
  Future<SurahTextModel> _loadSurah(SurahTextParams params) async {
    try {
      return _local.getCachedSurah(params.surahNumber);
    } on CacheException {
      final surah = await _remote.getSurahText(params);
      await _local.cacheSurah(surah);
      return surah;
    }
  }
}
