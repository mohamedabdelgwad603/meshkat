import 'package:dartz/dartz.dart';
import 'package:mishkat/core/errors/exceptions.dart';
import 'package:mishkat/core/errors/failure.dart';
import 'package:mishkat/core/errors/safe_execute.dart';
import 'package:mishkat/features/tafsir/data/datasources/tafsir_local_data_source.dart';
import 'package:mishkat/features/tafsir/data/datasources/tafsir_remote_data_source.dart';
import 'package:mishkat/features/tafsir/data/models/tafsir_edition_model.dart';
import 'package:mishkat/features/tafsir/data/models/tafsir_model.dart';
import 'package:mishkat/features/tafsir/data/requests_params/editions_params.dart';
import 'package:mishkat/features/tafsir/data/requests_params/tafsir_params.dart';
import 'package:mishkat/features/tafsir/domain/repo/tafsir_repo.dart';

// Implementation of TafsirRepo that caches the book list and orders it for display.
class TafsirRepoImp implements TafsirRepo {
  final TafsirRemoteDataSource _remote;
  final TafsirLocalDataSource _local;

  // Creates the repository with its data sources.
  TafsirRepoImp(this._remote, this._local);

  // Keywords of the best-known tafsir books in display order.
  static const List<String> _preferredOrder = [
    'muyassar', 'kath', 'saad', 'sadi', 'saddi', 'tabari', 'jalalayn', 'qurtubi', 'baghawi', 'waseet', 'miqbas',
  ];

  // Returns the Arabic tafsir books, best-known ones first.
  @override
  Future<Either<Failure, List<TafsirEditionModel>>> getEditions() => safeExecute(request: () async {
        try {
          return _local.getCachedEditions();
        } on CacheException {
          final editions = _sort(await _remote.getEditions(EditionsParams.arabicTafsir));
          await _local.cacheEditions(editions);
          return editions;
        }
      });

  // Returns the tafsir of one ayah.
  @override
  Future<Either<Failure, TafsirModel>> getTafsir(TafsirParams params) =>
      safeExecute(request: () => _remote.getTafsir(params));

  // Returns the identifier of the chosen tafsir book.
  @override
  String getSelectedEdition() => _local.getSelectedEdition();

  // Saves the identifier of the chosen tafsir book.
  @override
  Future<void> saveSelectedEdition(String identifier) => _local.saveSelectedEdition(identifier);

  // Orders editions by the preferred keyword list, keeping unknown ones at the end.
  List<TafsirEditionModel> _sort(List<TafsirEditionModel> editions) {
    int rank(TafsirEditionModel e) {
      final id = e.identifier.replaceFirst('ar.', '');
      final index = _preferredOrder.indexWhere(id.contains);
      return index < 0 ? _preferredOrder.length : index;
    }

    return [...editions]..sort((a, b) => rank(a).compareTo(rank(b)));
  }
}
