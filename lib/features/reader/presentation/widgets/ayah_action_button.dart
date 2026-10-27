import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat/config/themes/color_manager.dart';
import 'package:mishkat/config/themes/text_styles.dart';
import 'package:mishkat/core/utills/functions/spacing.dart';
import 'package:mishkat/core/utills/widgets/custom_text.dart';

// Square icon button with a label used in the selected-ayah panel.
class AyahActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isPrimary;

  // Creates the button.
  const AyahActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.isPrimary = false,
  });

  // Builds the rounded icon square and its label.
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18.r),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 2.h),
          child: Column(
            children: [
              Container(
                width: 52.r,
                height: 52.r,
                decoration: BoxDecoration(
                  color: isPrimary ? ColorsManager.primary : ColorsManager.primaryLight,
                  borderRadius: BorderRadius.circular(18.r),
                ),
                child: Icon(icon, size: 22.r, color: isPrimary ? ColorsManager.white : ColorsManager.primary),
              ),
              verticalSpace(6.h),
              CustomText(text: label, maxLines: 1, style: getSemiBoldStyle(context: context, fontSize: 12.sp)),
            ],
          ),
        ),
      ),
    );
  }
}
