import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat/config/themes/color_manager.dart';
import 'package:mishkat/config/themes/text_styles.dart';
import 'package:mishkat/core/utills/functions/spacing.dart';
import 'package:mishkat/core/utills/text_manager.dart';
import 'package:mishkat/core/utills/widgets/custom_text.dart';

// Arabic / English switch for the app language.
class LanguageSelector extends StatelessWidget {
  // Creates the selector.
  const LanguageSelector({super.key});

  // Builds the label and a two-option segmented control.
  @override
  Widget build(BuildContext context) {
    final isArabic = context.locale.languageCode == 'ar';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CustomText(text: TextManager.language, style: getSemiBoldStyle(context: context)),
        verticalSpace(10.h),
        Row(
          children: [
            _LanguageOption(label: TextManager.arabic, selected: isArabic, locale: const Locale('ar')),
            horizontalSpace(8.w),
            _LanguageOption(label: TextManager.english, selected: !isArabic, locale: const Locale('en')),
          ],
        ),
      ],
    );
  }
}

// One language option button.
class _LanguageOption extends StatelessWidget {
  final String label;
  final bool selected;
  final Locale locale;

  // Creates the option.
  const _LanguageOption({required this.label, required this.selected, required this.locale});

  // Builds a filled or outlined pill that switches the locale.
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: OutlinedButton(
        onPressed: selected ? null : () => context.setLocale(locale),
        style: OutlinedButton.styleFrom(
          minimumSize: Size(0, 44.h),
          backgroundColor: selected ? ColorsManager.primary : ColorsManager.surface,
          disabledBackgroundColor: ColorsManager.primary,
          side: BorderSide(color: selected ? ColorsManager.primary : ColorsManager.greyLight),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
        ),
        child: CustomText(
          text: label,
          style: getSemiBoldStyle(context: context, color: selected ? ColorsManager.white : ColorsManager.darkLight),
        ),
      ),
    );
  }
}
