import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat/config/themes/color_manager.dart';
import 'package:mishkat/config/themes/text_styles.dart';
import 'package:mishkat/core/utills/functions/spacing.dart';
import 'package:mishkat/core/utills/widgets/custom_text.dart';

// Rounded icon tile with a label used in the home shortcuts row.
class QuickActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  // Creates the tile.
  const QuickActionTile({super.key, required this.icon, required this.label, required this.onTap});

  // Builds the icon square and label.
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20.r),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 4.h),
          child: Column(
            children: [
              Container(
                width: 60.r,
                height: 60.r,
                decoration: BoxDecoration(
                  color: ColorsManager.primaryLight,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Icon(icon, size: 26.r, color: ColorsManager.primary),
              ),
              verticalSpace(8.h),
              CustomText(
                text: label,
                maxLines: 1,
                style: getSemiBoldStyle(context: context, fontSize: 13.sp),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
