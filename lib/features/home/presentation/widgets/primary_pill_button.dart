import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat/config/themes/color_manager.dart';
import 'package:mishkat/config/themes/text_styles.dart';
import 'package:mishkat/core/utills/functions/spacing.dart';
import 'package:mishkat/core/utills/widgets/custom_text.dart';

// Rounded green button with a label and a forward chevron.
class PrimaryPillButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  // Creates the button.
  const PrimaryPillButton({super.key, required this.label, required this.onPressed});

  // Builds the pill-shaped button.
  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: ColorsManager.primary,
        foregroundColor: ColorsManager.white,
        minimumSize: Size(0, 44.h),
        padding: EdgeInsets.symmetric(horizontal: 18.w),
        shape: const StadiumBorder(),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomText(text: label, style: getSemiBoldStyle(context: context, color: ColorsManager.white)),
          horizontalSpace(6.w),
          Icon(Icons.arrow_forward_ios_rounded, size: 14.r),
        ],
      ),
    );
  }
}
