import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat/config/themes/color_manager.dart';
import 'package:mishkat/config/themes/text_styles.dart';
import 'package:mishkat/core/utills/functions/spacing.dart';
import 'package:mishkat/core/utills/widgets/custom_text.dart';

// Row of equal pills for picking one value, with a title above it.
class HifzChoiceChips<T> extends StatelessWidget {
  final String title;
  final String? hint;
  final List<T> options;
  final T selected;
  final String Function(T value) labelOf;
  final bool translateLabels;
  final ValueChanged<T> onSelected;

  // Creates the chips.
  const HifzChoiceChips({
    super.key,
    required this.title,
    required this.options,
    required this.selected,
    required this.labelOf,
    required this.onSelected,
    this.hint,
    this.translateLabels = false,
  });

  // Builds the title, optional hint and the pills.
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CustomText(text: title, style: getSemiBoldStyle(context: context, fontSize: 14.sp)),
        if (hint != null) ...[
          verticalSpace(2.h),
          CustomText(
            text: hint!,
            style: getRegularStyle(context: context, fontSize: 12.sp, color: ColorsManager.grey),
          ),
        ],
        verticalSpace(10.h),
        Row(
          children: [
            for (final option in options)
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 3.w),
                  child: _buildPill(context, option),
                ),
              ),
          ],
        ),
      ],
    );
  }

  // Builds one pill, filled when selected.
  Widget _buildPill(BuildContext context, T option) {
    final isSelected = option == selected;
    return Semantics(
      selected: isSelected,
      button: true,
      child: InkWell(
        onTap: () => onSelected(option),
        borderRadius: BorderRadius.circular(14.r),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          height: 40.h,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? ColorsManager.primary : ColorsManager.greyBackground,
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(color: isSelected ? ColorsManager.primary : ColorsManager.greyLight),
          ),
          child: CustomText(
            text: labelOf(option),
            translate: translateLabels,
            maxLines: 1,
            style: getSemiBoldStyle(
              context: context,
              fontSize: 13.sp,
              color: isSelected ? ColorsManager.white : ColorsManager.darkLight,
            ),
          ),
        ),
      ),
    );
  }
}
