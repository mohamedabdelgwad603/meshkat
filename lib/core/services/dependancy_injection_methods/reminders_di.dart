import 'package:mishkat/core/services/dependancy_injection_methods/init_di.dart';
import 'package:mishkat/features/reminders/data/datasources/reminders_local_data_source.dart';
import 'package:mishkat/features/reminders/data/repo_imp/reminders_repo_imp.dart';
import 'package:mishkat/features/reminders/domain/repo/reminders_repo.dart';
import 'package:mishkat/features/reminders/presentation/cubit/reminders_cubit.dart';

// Registers the daily reminders dependencies.
void setupRemindersDi() {
  getIt.registerLazySingleton<RemindersLocalDataSource>(() => RemindersLocalDataSourceImp(getIt()));
  getIt.registerLazySingleton<RemindersRepo>(() => RemindersRepoImp(getIt()));
  getIt.registerFactory(() => RemindersCubit(getIt()));
}
