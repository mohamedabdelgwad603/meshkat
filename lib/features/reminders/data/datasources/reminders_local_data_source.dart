import 'package:mishkat/core/services/notifications/local_notifications_service.dart';
import 'package:mishkat/features/reminders/data/models/daily_reminder_model.dart';
import 'package:mishkat/features/reminders/data/requests_params/schedule_reminders_params.dart';

// Schedules the daily reminders as local notifications on the device.
abstract class RemindersLocalDataSource {
  // Asks for notification permission and schedules every daily reminder.
  Future<void> scheduleDailyReminders(ScheduleRemindersParams params);
}

// Local notifications implementation of RemindersLocalDataSource.
class RemindersLocalDataSourceImp implements RemindersLocalDataSource {
  final LocalNotificationsService _notifications;

  // Creates the data source with the notifications service.
  RemindersLocalDataSourceImp(this._notifications);

  // Asks for notification permission and schedules every daily reminder.
  @override
  Future<void> scheduleDailyReminders(ScheduleRemindersParams params) async {
    await _notifications.requestPermission();
    for (final reminder in DailyReminderModel.all) {
      await _notifications.scheduleDaily(
        id: reminder.id,
        title: params.title,
        body: params.messages[reminder.messageKey] ?? reminder.messageKey,
        hour: reminder.hour,
        minute: reminder.minute,
      );
    }
  }
}
