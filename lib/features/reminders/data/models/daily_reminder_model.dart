import 'package:mishkat/core/utills/text_manager.dart';

// One daily reminder: its notification id, time of day and message translation key.
class DailyReminderModel {
  final int id;
  final int hour;
  final int minute;
  final String messageKey;

  // Creates a reminder.
  const DailyReminderModel({required this.id, required this.hour, required this.minute, required this.messageKey});

  // The five daily reminders, ordered from morning to bedtime.
  static const List<DailyReminderModel> all = [
    DailyReminderModel(id: 1001, hour: 8, minute: 0, messageKey: TextManager.reminderQuran),
    DailyReminderModel(id: 1002, hour: 12, minute: 0, messageKey: TextManager.reminderSalawat),
    DailyReminderModel(id: 1003, hour: 16, minute: 0, messageKey: TextManager.reminderSayAllah),
    DailyReminderModel(id: 1004, hour: 19, minute: 0, messageKey: TextManager.reminderTahlil),
    DailyReminderModel(id: 1005, hour: 22, minute: 0, messageKey: TextManager.reminderTawbah),
  ];

  // Creates a placeholder reminder for skeleton loading.
  factory DailyReminderModel.dummy() =>
      const DailyReminderModel(id: 0, hour: 8, minute: 0, messageKey: TextManager.reminderQuran);
}
