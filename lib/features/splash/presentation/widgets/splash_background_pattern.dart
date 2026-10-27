import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat/config/themes/color_manager.dart';
import 'package:mishkat/core/utills/widgets/islamic_star_painter.dart';

// Draws the large faint eight-point star with two rings behind the splash content.
class SplashBackgroundPattern extends StatelessWidget {
  // Creates the background pattern.
  const SplashBackgroundPattern({super.key});

  // Builds the oversized star centered on the screen.
  @override
  Widget build(BuildContext context) {
    return OverflowBox(
      maxWidth: double.infinity,
      maxHeight: double.infinity,
      child: IslamicStar(
        size: 500.w,
        color: ColorsManager.secondry,
        strokeWidth: 2.w,
        withRings: true,
        innerRingRatio: 0.25,
        opacity: 0.16,
      ),
    );
  }
}
