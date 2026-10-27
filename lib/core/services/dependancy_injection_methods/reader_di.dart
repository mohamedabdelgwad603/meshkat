import 'package:mishkat/core/services/dependancy_injection_methods/init_di.dart';
import 'package:mishkat/features/reader/data/datasources/mushaf_script_local_data_source.dart';
import 'package:mishkat/features/reader/data/datasources/reader_local_data_source.dart';
import 'package:mishkat/features/reader/data/datasources/reader_remote_data_source.dart';
import 'package:mishkat/features/reader/data/repo_imp/reader_repo_imp.dart';
import 'package:mishkat/features/reader/domain/repo/reader_repo.dart';
import 'package:mishkat/features/reader/presentation/cubit/reader_cubit.dart';

// Registers the mushaf reader dependencies.
void setupReaderDi() {
  getIt.registerLazySingleton<ReaderRemoteDataSource>(() => ReaderRemoteDataSourceImp(getIt()));
  getIt.registerLazySingleton<ReaderLocalDataSource>(() => ReaderLocalDataSourceImp(getIt()));
  getIt.registerLazySingleton<MushafScriptLocalDataSource>(() => MushafScriptLocalDataSourceImp());
  getIt.registerLazySingleton<ReaderRepo>(() => ReaderRepoImp(getIt(), getIt(), getIt()));
  getIt.registerFactory(() => ReaderCubit(getIt(), getIt()));
}
