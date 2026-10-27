import 'package:mishkat/core/services/dependancy_injection_methods/init_di.dart';
import 'package:mishkat/features/home/data/datasources/home_local_data_source.dart';
import 'package:mishkat/features/home/data/datasources/home_remote_data_source.dart';
import 'package:mishkat/features/home/data/repo_imp/home_repo_imp.dart';
import 'package:mishkat/features/home/domain/repo/home_repo.dart';
import 'package:mishkat/features/home/presentation/cubit/home_cubit.dart';

// Registers the home screen dependencies.
void setupHomeDi() {
  getIt.registerLazySingleton<HomeRemoteDataSource>(() => HomeRemoteDataSourceImp(getIt()));
  getIt.registerLazySingleton<HomeLocalDataSource>(() => HomeLocalDataSourceImp(getIt()));
  getIt.registerLazySingleton<HomeRepo>(() => HomeRepoImp(getIt(), getIt()));
  getIt.registerFactory(() => HomeCubit(getIt()));
}
