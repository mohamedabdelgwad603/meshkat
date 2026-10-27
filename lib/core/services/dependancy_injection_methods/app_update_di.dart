import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:mishkat/core/services/dependancy_injection_methods/init_di.dart';
import 'package:mishkat/features/app_update/data/datasources/app_update_remote_data_source.dart';
import 'package:mishkat/features/app_update/data/repo_imp/app_update_repo_imp.dart';
import 'package:mishkat/features/app_update/domain/repo/app_update_repo.dart';
import 'package:mishkat/features/app_update/presentation/cubit/app_update_cubit.dart';

// Registers the app update dependencies.
void setupAppUpdateDi() {
  getIt.registerLazySingleton<FirebaseRemoteConfig>(() => FirebaseRemoteConfig.instance);
  getIt.registerLazySingleton<AppUpdateRemoteDataSource>(() => AppUpdateRemoteDataSourceImp(getIt()));
  getIt.registerLazySingleton<AppUpdateRepo>(() => AppUpdateRepoImp(getIt()));
  getIt.registerFactory(() => AppUpdateCubit(getIt()));
}
