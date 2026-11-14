import 'package:mishkat/core/services/dependancy_injection_methods/init_di.dart';
import 'package:mishkat/features/reflections/data/datasources/reflections_local_data_source.dart';
import 'package:mishkat/features/reflections/data/repo_imp/reflections_repo_imp.dart';
import 'package:mishkat/features/reflections/domain/repo/reflections_repo.dart';
import 'package:mishkat/features/reflections/presentation/cubit/reflections_cubit.dart';

// Registers the reflection notebook dependencies; the cubit is shared app-wide.
void setupReflectionsDi() {
  getIt.registerLazySingleton<ReflectionsLocalDataSource>(() => ReflectionsLocalDataSourceImp(getIt()));
  getIt.registerLazySingleton<ReflectionsRepo>(() => ReflectionsRepoImp(getIt()));
  getIt.registerLazySingleton(() => ReflectionsCubit(getIt()));
}
