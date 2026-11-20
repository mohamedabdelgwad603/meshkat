import 'package:mishkat/core/services/dependancy_injection_methods/init_di.dart';
import 'package:mishkat/features/mutashabihat/data/datasources/mutashabihat_local_data_source.dart';
import 'package:mishkat/features/mutashabihat/data/repo_imp/mutashabihat_repo_imp.dart';
import 'package:mishkat/features/mutashabihat/domain/repo/mutashabihat_repo.dart';
import 'package:mishkat/features/mutashabihat/presentation/cubit/mutashabih_phrase_cubit.dart';
import 'package:mishkat/features/mutashabihat/presentation/cubit/mutashabihat_browse_cubit.dart';
import 'package:mishkat/features/mutashabihat/presentation/cubit/mutashabihat_cubit.dart';
import 'package:mishkat/features/mutashabihat/presentation/cubit/mutashabihat_index_cubit.dart';

// Registers the mutashabihat dependencies; the index cubit is shared app-wide.
void setupMutashabihatDi() {
  getIt.registerLazySingleton<MutashabihatLocalDataSource>(() => MutashabihatLocalDataSourceImp());
  getIt.registerLazySingleton<MutashabihatRepo>(() => MutashabihatRepoImp(getIt(), getIt()));
  getIt.registerLazySingleton(() => MutashabihatIndexCubit(getIt()));
  getIt.registerFactory(() => MutashabihatCubit(getIt()));
  getIt.registerFactory(() => MutashabihatBrowseCubit(getIt()));
  getIt.registerFactory(() => MutashabihPhraseCubit(getIt()));
}
