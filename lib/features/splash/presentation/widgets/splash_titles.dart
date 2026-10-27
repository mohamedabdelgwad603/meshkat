import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat/config/themes/color_manager.dart';
import 'package:mishkat/config/themes/font_manager.dart';
import 'package:mishkat/config/themes/text_styles.dart';
import 'package:mishkat/core/utills/functions/spacing.dart';
import 'package:mishkat/core/utills/text_manager.dart';
import 'package:mishkat/core/utills/widgets/custom_text.dart';

// Shows the app name, the "light upon light" phrase and the tagline.
class SplashTitles extends StatelessWidget {
  // Creates the splash titles.
  const SplashTitles({super.key});

  // Builds the three centered lines of brand text.
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomText(
          text: TextManager.appName,
          textAlign: TextAlign.center,
          style: getBoldStyle(
            context: context,
            fontSize: 64.sp,
            height: 1.3,
            color: ColorsManager.secondry,
            fontFamily: FontManager.heading,
          ),
        ),
        CustomText(
          text: TextManager.lightUponLight,
          textAlign: TextAlign.center,
          style: getRegularStyle(
            context: context,
            fontSize: 20.sp,
            height: 1.6,
            color: ColorsManager.white,
            fontFamily: FontManager.heading,
          ),
        ),
        verticalSpace(2.h),
        CustomText(
          text: TextManager.appTagline,
          textAlign: TextAlign.center,
          style: getRegularStyle(context: context, fontSize: 13.sp, color: ColorsManager.mutedOnDark),
        ),
      ],
    );
  }
}
