import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat/config/themes/color_manager.dart';
import 'package:mishkat/config/themes/text_styles.dart';
import 'package:mishkat/core/utills/functions/spacing.dart';
import 'package:mishkat/core/utills/text_manager.dart';
import 'package:mishkat/core/utills/widgets/custom_text.dart';
import 'package:mishkat/features/hifz/presentation/cubit/hifz_test_cubit.dart';

// Buttons under a test ayah: reveal while hidden, rate once shown, hide again once rated.
class HifzTestActions extends StatelessWidget {
  final bool isFullyRevealed;
  final bool isRated;
  final HifzTestCubit cubit;
  final int index;

  // Creates the buttons for the ayah at the given index.
  const HifzTestActions({
    super.key,
    required this.isFullyRevealed,
    required this.isRated,
    required this.cubit,
    required this.index,
  });

  // Builds the buttons matching the ayah's step.
  @override
  Widget build(BuildContext context) {
    if (!isFullyRevealed) {
      return Row(
        children: [
          Expanded(
            child: _button(
              context,
              icon: Icons.add_rounded,
              label: TextManager.hifzRevealWord,
              color: ColorsManager.primary,
              background: ColorsManager.primaryLight,
              onTap: () => cubit.revealWord(index),
            ),
          ),
          horizontalSpace(8.w),
          Expanded(
            child: _button(
              context,
              icon: Icons.visibility_outlined,
              label: TextManager.hifzRevealAyah,
              color: ColorsManager.white,
              background: ColorsManager.primary,
              onTap: () => cubit.revealAyah(index),
            ),
          ),
        ],
      );
    }
    if (isRated) {
      return Align(
        alignment: AlignmentDirectional.centerEnd,
        child: TextButton.icon(
          onPressed: () => cubit.hideAyah(index),
          icon: Icon(Icons.visibility_off_outlined, size: 16.r, color: ColorsManager.grey),
          label: CustomText(
            text: TextManager.hifzHide,
            style: getSemiBoldStyle(context: context, fontSize: 13.sp, color: ColorsManager.grey),
          ),
        ),
      );
    }
    return Row(
      children: [
        Expanded(
          child: _button(
            context,
            icon: Icons.refresh_rounded,
            label: TextManager.hifzNeedsReview,
            color: ColorsManager.red,
            background: ColorsManager.redLight,
            onTap: () => cubit.rate(index, memorized: false),
          ),
        ),
        horizontalSpace(8.w),
        Expanded(
          child: _button(
            context,
            icon: Icons.check_rounded,
            label: TextManager.hifzMemorized,
            color: ColorsManager.white,
            background: ColorsManager.green,
            onTap: () => cubit.rate(index, memorized: true),
          ),
        ),
      ],
    );
  }

  // Builds one rounded button with an icon and a label.
  Widget _button(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required Color background,
    required VoidCallback onTap,
  }) {
    return Material(
      color: background,
      borderRadius: BorderRadius.circular(14.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14.r),
        child: SizedBox(
          height: 42.h,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18.r, color: color),
              horizontalSpace(6.w),
              Flexible(
                child: CustomText(
                  text: label,
                  maxLines: 1,
                  style: getSemiBoldStyle(context: context, fontSize: 13.sp, color: color),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
