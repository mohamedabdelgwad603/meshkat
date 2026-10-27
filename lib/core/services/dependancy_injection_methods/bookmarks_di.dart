import 'package:mishkat/core/services/dependancy_injection_methods/init_di.dart';
import 'package:mishkat/features/bookmarks/data/datasources/bookmarks_local_data_source.dart';
import 'package:mishkat/features/bookmarks/data/repo_imp/bookmarks_repo_imp.dart';
import 'package:mishkat/features/bookmarks/domain/repo/bookmarks_repo.dart';
import 'package:mishkat/features/bookmarks/presentation/cubit/bookmarks_cubit.dart';

// Registers the bookmarks dependencies; the cubit is shared app-wide.
void setupBookmarksDi() {
  getIt.registerLazySingleton<BookmarksLocalDataSource>(() => BookmarksLocalDataSourceImp(getIt()));
  getIt.registerLazySingleton<BookmarksRepo>(() => BookmarksRepoImp(getIt(), getIt()));
  getIt.registerLazySingleton(() => BookmarksCubit(getIt()));
}
