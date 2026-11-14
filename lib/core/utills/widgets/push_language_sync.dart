import 'package:flutter/material.dart';
import 'package:mishkat/core/services/dependancy_injection_methods/init_di.dart';
import 'package:mishkat/core/services/notifications/push_notifications_service.dart';

// Keeps the push topic subscription in line with the app language.
class PushLanguageSync extends StatefulWidget {
  final Widget child;

  // Creates the sync widget around the app content.
  const PushLanguageSync({super.key, required this.child});

  // Creates the sync state.
  @override
  State<PushLanguageSync> createState() => _PushLanguageSyncState();
}

// Remembers the last synced language so topics only change on a real switch.
class _PushLanguageSyncState extends State<PushLanguageSync> {
  String? _syncedLanguage;

  // Moves the device to the topic of the new language whenever it changes.
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final language = Localizations.localeOf(context).languageCode;
    if (language == _syncedLanguage) return;
    _syncedLanguage = language;
    getIt<PushNotificationsService>().syncLanguage(language);
  }

  // Shows the app content unchanged.
  @override
  Widget build(BuildContext context) => widget.child;
}
