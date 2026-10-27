import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat/config/themes/color_manager.dart';
import 'package:mishkat/config/themes/text_styles.dart';
import 'package:mishkat/core/utills/functions/localized_digits.dart';
import 'package:mishkat/core/utills/functions/spacing.dart';
import 'package:mishkat/core/utills/text_manager.dart';
import 'package:mishkat/core/utills/widgets/custom_text.dart';

// Shows the installed version and the new version side by side with an arrow between them.
class AppUpdateVersionsRow extends StatelessWidget {
  final String currentVersion;
  final String latestVersion;

  // Creates the row.
  const AppUpdateVersionsRow({super.key, required this.currentVersion, required this.latestVersion});

  // Builds the two version cards and the arrow.
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _VersionCard(label: TextManager.updateCurrentVersion, version: currentVersion, highlighted: false),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Icon(Icons.arrow_forward_rounded, size: 20.r, color: ColorsManager.secondry),
        ),
        Expanded(
          child: _VersionCard(label: TextManager.updateNewVersion, version: latestVersion, highlighted: true),
        ),
      ],
    );
  }
}

// One version card with its label and number.
class _VersionCard extends StatelessWidget {
  final String label;
  final String version;
  final bool highlighted;

  // Creates the card.
  const _VersionCard({required this.label, required this.version, required this.highlighted});

  // Builds the card, gold-tinted when it is the new version.
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      decoration: BoxDecoration(
        color: highlighted ? ColorsManager.goldOverlay : ColorsManager.greyBackground,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: highlighted ? ColorsManager.goldBorder : ColorsManager.divider),
      ),
      child: Column(
        children: [
          CustomText(
            text: label,
            style: getMediumStyle(context: context, fontSize: 12.sp, color: ColorsManager.grey),
          ),
          verticalSpace(2.h),
          CustomText(
            text: localizedDigits(context, version),
            translate: false,
            textDirection: TextDirection.ltr,
            style: getBoldStyle(
              context: context,
              fontSize: 17.sp,
              color: highlighted ? ColorsManager.secondryDark : ColorsManager.darkLight,
            ),
          ),
        ],
      ),
    );
  }
}
