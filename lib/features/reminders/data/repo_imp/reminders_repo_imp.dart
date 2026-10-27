import 'package:dartz/dartz.dart';
import 'package:mishkat/core/errors/failure.dart';
import 'package:mishkat/core/errors/safe_execute.dart';
import 'package:mishkat/features/reminders/data/datasources/reminders_local_data_source.dart';
import 'package:mishkat/features/reminders/data/requests_params/schedule_reminders_params.dart';
import 'package:mishkat/features/reminders/domain/repo/reminders_repo.dart';

// Local implementation of RemindersRepo.
class RemindersRepoImp implements RemindersRepo {
  final RemindersLocalDataSource _local;

  // Creates the repository with its local data source.
  RemindersRepoImp(this._local);

  // Schedules every daily reminder with the given texts.
  @override
  Future<Either<Failure, Unit>> scheduleDailyReminders(ScheduleRemindersParams params) => safeExecute(request: () async {
        await _local.scheduleDailyReminders(params);
        return unit;
      });
}
