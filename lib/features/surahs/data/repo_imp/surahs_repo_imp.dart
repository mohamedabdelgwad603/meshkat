import 'package:dartz/dartz.dart';
import 'package:mishkat/core/errors/exceptions.dart';
import 'package:mishkat/core/errors/failure.dart';
import 'package:mishkat/core/errors/safe_execute.dart';
import 'package:mishkat/features/surahs/data/datasources/surahs_local_data_source.dart';
import 'package:mishkat/features/surahs/data/datasources/surahs_remote_data_source.dart';
import 'package:mishkat/features/surahs/data/models/juz_model.dart';
import 'package:mishkat/features/surahs/data/models/surah_model.dart';
import 'package:mishkat/features/surahs/domain/repo/surahs_repo.dart';

// Cache-first implementation of SurahsRepo; the list never changes once downloaded.
class SurahsRepoImp implements SurahsRepo {
  final SurahsRemoteDataSource _remote;
  final SurahsLocalDataSource _local;

  // Creates the repository with its data sources.
  SurahsRepoImp(this._remote, this._local);

  // Returns all surahs, from cache when available and from the network otherwise.
  @override
  Future<Either<Failure, List<SurahModel>>> getSurahs() => safeExecute(request: _loadSurahs);

  // Returns one surah's metadata by its number.
  @override
  Future<Either<Failure, SurahModel>> getSurah(int number) => safeExecute(request: () async {
        final surahs = await _loadSurahs();
        return surahs.firstWhere((s) => s.number == number);
      });

  // Returns the thirty juz with their starting positions.
  @override
  List<JuzModel> getJuzList() => _local.getJuzList();

  // Reads the cached list or downloads and caches it.
  Future<List<SurahModel>> _loadSurahs() async {
    try {
      return _local.getCachedSurahs();
    } on CacheException {
      final surahs = await _remote.getSurahs();
      await _local.cacheSurahs(surahs);
      return surahs;
    }
  }
}
