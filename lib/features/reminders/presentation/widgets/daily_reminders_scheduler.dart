import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mishkat/core/utills/text_manager.dart';
import 'package:mishkat/features/reminders/data/models/daily_reminder_model.dart';
import 'package:mishkat/features/reminders/data/requests_params/schedule_reminders_params.dart';
import 'package:mishkat/features/reminders/presentation/cubit/reminders_cubit.dart';

// Schedules the daily reminders in the current language and reschedules them when the language changes.
class DailyRemindersScheduler extends StatefulWidget {
  final Widget child;

  // Creates the scheduler around the app content.
  const DailyRemindersScheduler({super.key, required this.child});

  // Creates the scheduler state.
  @override
  State<DailyRemindersScheduler> createState() => _DailyRemindersSchedulerState();
}

// Remembers the last scheduled language so reminders are only rescheduled on a real change.
class _DailyRemindersSchedulerState extends State<DailyRemindersScheduler> {
  Locale? _scheduledLocale;

  // Reschedules the reminders whenever the loaded translations switch to a new language.
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final locale = Localizations.localeOf(context);
    if (locale == _scheduledLocale) return;
    _scheduledLocale = locale;
    RemindersCubit.get(context).scheduleDailyReminders(_buildParams());
  }

  // Builds the reminder texts translated into the current language.
  ScheduleRemindersParams _buildParams() => ScheduleRemindersParams(
        title: TextManager.appName.tr(context: context),
        messages: {
          for (final reminder in DailyReminderModel.all) reminder.messageKey: reminder.messageKey.tr(context: context),
        },
      );

  // Shows the app content unchanged.
  @override
  Widget build(BuildContext context) => widget.child;
}
