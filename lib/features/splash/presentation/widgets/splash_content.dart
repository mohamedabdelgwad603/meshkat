import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat/core/utills/functions/spacing.dart';
import 'package:mishkat/core/utills/widgets/app_logo.dart';
import 'package:mishkat/features/splash/presentation/widgets/splash_titles.dart';

// Fades in the logo and the brand titles stacked in the center of the splash.
class SplashContent extends StatelessWidget {
  // Creates the splash content.
  const SplashContent({super.key});

  // Builds the logo and titles with a soft fade and rise on entry.
  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 900),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) => Opacity(
        opacity: value,
        child: Transform.translate(offset: Offset(0, (1 - value) * 16.h), child: child),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppLogo(size: 192.w),
          verticalSpace(4.h),
          const SplashTitles(),
        ],
      ),
    );
  }
}
