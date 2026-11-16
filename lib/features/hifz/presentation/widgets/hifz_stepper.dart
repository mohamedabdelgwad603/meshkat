import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat/config/themes/color_manager.dart';
import 'package:mishkat/config/themes/text_styles.dart';
import 'package:mishkat/core/utills/functions/localized_digits.dart';
import 'package:mishkat/core/utills/functions/spacing.dart';
import 'package:mishkat/core/utills/text_manager.dart';
import 'package:mishkat/core/utills/widgets/custom_text.dart';
import 'package:mishkat/core/utills/widgets/round_icon_button.dart';

// Labeled number picker with minus and plus buttons limited to a range.
class HifzStepper extends StatelessWidget {
  final String label;
  final int value;
  final int min;
  final int max;
  final ValueChanged<int> onChanged;

  // Creates the stepper.
  const HifzStepper({
    super.key,
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  // Builds the label above the minus button, the value and the plus button.
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 8.h),
      decoration: BoxDecoration(color: ColorsManager.greyBackground, borderRadius: BorderRadius.circular(16.r)),
      child: Column(
        children: [
          CustomText(text: label, style: getMediumStyle(context: context, fontSize: 12.sp, color: ColorsManager.grey)),
          verticalSpace(4.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RoundIconButton(
                icon: Icons.remove_rounded,
                semanticLabel: TextManager.hifzPrevious,
                size: 36,
                iconSize: 18,
                backgroundColor: value > min ? ColorsManager.primaryLight : ColorsManager.track,
                iconColor: value > min ? ColorsManager.primary : ColorsManager.mutedOnDark,
                onPressed: value > min ? () => onChanged(value - 1) : null,
              ),
              CustomText(
                text: localizedDigits(context, value),
                translate: false,
                style: getBoldStyle(context: context, fontSize: 20.sp, color: ColorsManager.primary),
              ),
              RoundIconButton(
                icon: Icons.add_rounded,
                semanticLabel: TextManager.hifzNext,
                size: 36,
                iconSize: 18,
                backgroundColor: value < max ? ColorsManager.primaryLight : ColorsManager.track,
                iconColor: value < max ? ColorsManager.primary : ColorsManager.mutedOnDark,
                onPressed: value < max ? () => onChanged(value + 1) : null,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
