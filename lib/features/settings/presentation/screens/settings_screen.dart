import 'package:flutter/material.dart';
import 'package:mishkat/features/settings/presentation/widgets/settings_body.dart';

// Settings tab: language, mushaf font size, default reciter and sources.
class SettingsScreen extends StatelessWidget {
  // Creates the settings screen.
  const SettingsScreen({super.key});

  // Builds the body; the settings cubit is provided app-wide.
  @override
  Widget build(BuildContext context) => const SettingsBody();
}
