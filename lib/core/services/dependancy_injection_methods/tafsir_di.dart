import 'package:mishkat/core/services/dependancy_injection_methods/init_di.dart';
import 'package:mishkat/features/tafsir/data/datasources/tafsir_local_data_source.dart';
import 'package:mishkat/features/tafsir/data/datasources/tafsir_remote_data_source.dart';
import 'package:mishkat/features/tafsir/data/repo_imp/tafsir_repo_imp.dart';
import 'package:mishkat/features/tafsir/domain/repo/tafsir_repo.dart';
import 'package:mishkat/features/tafsir/presentation/cubit/tafsir_cubit.dart';

// Registers the tafsir dependencies.
void setupTafsirDi() {
  getIt.registerLazySingleton<TafsirRemoteDataSource>(() => TafsirRemoteDataSourceImp(getIt()));
  getIt.registerLazySingleton<TafsirLocalDataSource>(() => TafsirLocalDataSourceImp(getIt()));
  getIt.registerLazySingleton<TafsirRepo>(() => TafsirRepoImp(getIt(), getIt()));
  getIt.registerFactory(() => TafsirCubit(getIt(), getIt()));
}
