import 'package:mishkat/core/services/dependancy_injection_methods/init_di.dart';
import 'package:mishkat/features/player/data/datasources/player_local_data_source.dart';
import 'package:mishkat/features/player/data/datasources/player_remote_data_source.dart';
import 'package:mishkat/features/player/data/repo_imp/player_repo_imp.dart';
import 'package:mishkat/features/player/domain/repo/player_repo.dart';
import 'package:mishkat/features/player/presentation/cubit/player_cubit.dart';

// Registers the player dependencies; the cubit is shared so playback survives navigation.
void setupPlayerDi() {
  getIt.registerLazySingleton<PlayerRemoteDataSource>(() => PlayerRemoteDataSourceImp(getIt()));
  getIt.registerLazySingleton<PlayerLocalDataSource>(() => PlayerLocalDataSourceImp(getIt()));
  getIt.registerLazySingleton<PlayerRepo>(() => PlayerRepoImp(getIt(), getIt()));
  getIt.registerLazySingleton(() => PlayerCubit(getIt(), getIt(), getIt()));
}
