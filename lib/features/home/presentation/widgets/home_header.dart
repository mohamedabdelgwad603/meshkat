import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat/config/themes/color_manager.dart';
import 'package:mishkat/config/themes/font_manager.dart';
import 'package:mishkat/config/themes/text_styles.dart';
import 'package:mishkat/core/utills/functions/spacing.dart';
import 'package:mishkat/core/utills/text_manager.dart';
import 'package:mishkat/core/utills/widgets/app_logo.dart';
import 'package:mishkat/core/utills/widgets/custom_text.dart';
import 'package:mishkat/core/utills/widgets/islamic_star_painter.dart';
import 'package:mishkat/core/utills/widgets/round_icon_button.dart';
import 'package:mishkat/features/layout/presentation/cubit/layout_cubit.dart';

// Green header with geometric decoration, greeting, app name and search button.
class HomeHeader extends StatelessWidget {
  final double height;

  // Creates the header with the given total height.
  const HomeHeader({super.key, required this.height});

  // Builds the decorated header.
  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      color: ColorsManager.primary,
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          PositionedDirectional(
            end: -60.w,
            top: -40.h,
            child: IslamicStar(size: 220.r, color: ColorsManager.secondry, strokeWidth: 0.9, withRings: true, opacity: 0.18),
          ),
          PositionedDirectional(
            end: 150.w,
            bottom: -50.h,
            child: IslamicStar(size: 120.r, color: ColorsManager.secondry, strokeWidth: 1, opacity: 0.12),
          ),
          SafeArea(
            bottom: false,
            child: Padding(
              padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _HeaderTitle()),
                  RoundIconButton(
                    icon: Icons.search_rounded,
                    semanticLabel: TextManager.searchQuran,
                    iconColor: ColorsManager.white,
                    backgroundColor: ColorsManager.whiteOverlay,
                    borderColor: ColorsManager.goldBorder,
                    onPressed: () => LayoutCubit.get(context).openSearch(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Greeting line above the logo and app name.
class _HeaderTitle extends StatelessWidget {
  // Builds the greeting and the logo with the app name.
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: TextManager.greeting,
          style: getMediumStyle(context: context, fontSize: 14.sp, color: ColorsManager.secondry),
        ),
        verticalSpace(6.h),
        Row(
          children: [
            AppLogo(size: 40.r),
            horizontalSpace(10.w),
            CustomText(
              text: TextManager.appName,
              style: getBoldStyle(
                context: context,
                fontSize: 36.sp,
                color: ColorsManager.white,
                fontFamily: FontManager.heading,
                height: 1.2,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
