import 'package:dartz/dartz.dart';
import 'package:mishkat/core/errors/failure.dart';
import 'package:mishkat/features/reminders/data/requests_params/schedule_reminders_params.dart';

// Contract for the daily reminder notifications.
abstract class RemindersRepo {
  // Schedules every daily reminder with the given texts.
  Future<Either<Failure, Unit>> scheduleDailyReminders(ScheduleRemindersParams params);
}
