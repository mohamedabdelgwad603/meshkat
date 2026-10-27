import 'package:mishkat/core/services/dependancy_injection_methods/init_di.dart';
import 'package:mishkat/features/settings/data/datasources/settings_local_data_source.dart';
import 'package:mishkat/features/settings/data/repo_imp/settings_repo_imp.dart';
import 'package:mishkat/features/settings/domain/repo/settings_repo.dart';
import 'package:mishkat/features/settings/presentation/cubit/settings_cubit.dart';

// Registers the settings dependencies; the cubit is shared app-wide.
void setupSettingsDi() {
  getIt.registerLazySingleton<SettingsLocalDataSource>(() => SettingsLocalDataSourceImp(getIt()));
  getIt.registerLazySingleton<SettingsRepo>(() => SettingsRepoImp(getIt()));
  getIt.registerLazySingleton(() => SettingsCubit(getIt(), getIt(), getIt()));
}
