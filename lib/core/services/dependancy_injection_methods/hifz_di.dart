import 'package:mishkat/core/services/dependancy_injection_methods/init_di.dart';
import 'package:mishkat/features/hifz/data/datasources/hifz_local_data_source.dart';
import 'package:mishkat/features/hifz/data/repo_imp/hifz_repo_imp.dart';
import 'package:mishkat/features/hifz/domain/repo/hifz_repo.dart';
import 'package:mishkat/features/hifz/presentation/cubit/hifz_session_cubit.dart';
import 'package:mishkat/features/hifz/presentation/cubit/hifz_setup_cubit.dart';
import 'package:mishkat/features/hifz/presentation/cubit/hifz_test_cubit.dart';

// Registers the memorization mode dependencies; each screen gets its own cubit.
void setupHifzDi() {
  getIt.registerLazySingleton<HifzLocalDataSource>(() => HifzLocalDataSourceImp(getIt()));
  getIt.registerLazySingleton<HifzRepo>(() => HifzRepoImp(getIt(), getIt(), getIt()));
  getIt.registerFactory(() => HifzSetupCubit(getIt()));
  getIt.registerFactory(() => HifzSessionCubit(getIt(), getIt()));
  getIt.registerFactory(() => HifzTestCubit(getIt()));
}
