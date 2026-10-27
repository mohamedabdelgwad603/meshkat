// Already translated texts used to build the daily reminder notifications.
class ScheduleRemindersParams {
  final String title;
  final Map<String, String> messages;

  // Creates the params with the notification title and a message per translation key.
  const ScheduleRemindersParams({required this.title, required this.messages});

  // Serializes the params.
  Map<String, dynamic> toJson() => {'title': title, 'messages': messages};
}
