import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat/config/themes/color_manager.dart';
import 'package:mishkat/config/themes/text_styles.dart';
import 'package:mishkat/core/utills/functions/spacing.dart';
import 'package:mishkat/core/utills/text_manager.dart';
import 'package:mishkat/core/utills/widgets/app_logo.dart';
import 'package:mishkat/core/utills/widgets/custom_text.dart';
import 'package:mishkat/core/utills/widgets/islamic_star_painter.dart';

// Green banner with the faint star pattern, the logo and a "new update" badge.
class AppUpdateHeader extends StatelessWidget {
  // Creates the header.
  const AppUpdateHeader({super.key});

  // Builds the banner.
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24.r),
      child: Container(
        height: 168.h,
        color: ColorsManager.primary,
        child: Stack(
          alignment: Alignment.center,
          children: [
            OverflowBox(
              maxWidth: double.infinity,
              maxHeight: double.infinity,
              child: IslamicStar(
                size: 300.r,
                color: ColorsManager.secondry,
                strokeWidth: 1.5.r,
                withRings: true,
                innerRingRatio: 0.25,
                opacity: 0.18,
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppLogo(size: 92.r),
                verticalSpace(6.h),
                const _UpdateBadge(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Small gold pill reading "new update".
class _UpdateBadge extends StatelessWidget {
  // Creates the badge.
  const _UpdateBadge();

  // Builds the pill with an icon and label.
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: ColorsManager.goldOverlay,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: ColorsManager.goldBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.auto_awesome_rounded, size: 14.r, color: ColorsManager.secondry),
          horizontalSpace(6.w),
          CustomText(
            text: TextManager.updateBadge,
            style: getSemiBoldStyle(context: context, fontSize: 12.sp, color: ColorsManager.secondry),
          ),
        ],
      ),
    );
  }
}
