import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat/config/themes/color_manager.dart';
import 'package:mishkat/config/themes/text_styles.dart';
import 'package:mishkat/core/utills/functions/spacing.dart';
import 'package:mishkat/core/utills/widgets/custom_text.dart';

// One bottom-bar item with a pill behind the icon when active.
class AppBottomNavItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  // Creates the item.
  const AppBottomNavItem({
    super.key,
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  // Builds the icon pill and its label.
  @override
  Widget build(BuildContext context) {
    final color = isActive ? ColorsManager.primary : ColorsManager.grey;
    return Expanded(
      child: Semantics(
        selected: isActive,
        button: true,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14.r),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 2.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: isActive ? ColorsManager.primaryLight : ColorsManager.transparent,
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: Icon(isActive ? activeIcon : icon, size: 22.r, color: color),
                ),
                verticalSpace(4.h),
                CustomText(
                  text: label,
                  maxLines: 1,
                  style: isActive
                      ? getBoldStyle(context: context, fontSize: 11.sp, color: color)
                      : getMediumStyle(context: context, fontSize: 11.sp, color: color),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
