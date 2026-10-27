import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat/config/themes/color_manager.dart';

// Rounded cream card that groups one setting.
class SettingsCard extends StatelessWidget {
  final Widget child;

  // Creates the card around the given child.
  const SettingsCard({super.key, required this.child});

  // Builds the bordered card.
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: ColorsManager.surface,
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(color: ColorsManager.greyLight),
      ),
      child: child,
    );
  }
}
