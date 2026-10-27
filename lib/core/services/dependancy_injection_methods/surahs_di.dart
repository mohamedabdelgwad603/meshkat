import 'package:mishkat/core/services/dependancy_injection_methods/init_di.dart';
import 'package:mishkat/features/surahs/data/datasources/surahs_local_data_source.dart';
import 'package:mishkat/features/surahs/data/datasources/surahs_remote_data_source.dart';
import 'package:mishkat/features/surahs/data/repo_imp/surahs_repo_imp.dart';
import 'package:mishkat/features/surahs/domain/repo/surahs_repo.dart';
import 'package:mishkat/features/surahs/presentation/cubit/surahs_cubit.dart';

// Registers the surah index dependencies.
void setupSurahsDi() {
  getIt.registerLazySingleton<SurahsRemoteDataSource>(() => SurahsRemoteDataSourceImp(getIt()));
  getIt.registerLazySingleton<SurahsLocalDataSource>(() => SurahsLocalDataSourceImp(getIt()));
  getIt.registerLazySingleton<SurahsRepo>(() => SurahsRepoImp(getIt(), getIt()));
  getIt.registerFactory(() => SurahsCubit(getIt()));
}
