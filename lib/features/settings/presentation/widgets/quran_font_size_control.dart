import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat/config/themes/color_manager.dart';
import 'package:mishkat/config/themes/font_manager.dart';
import 'package:mishkat/config/themes/text_styles.dart';
import 'package:mishkat/core/utills/functions/localized_digits.dart';
import 'package:mishkat/core/utills/functions/spacing.dart';
import 'package:mishkat/core/utills/text_manager.dart';
import 'package:mishkat/core/utills/widgets/custom_text.dart';
import 'package:mishkat/features/settings/presentation/cubit/settings_cubit.dart';

// Slider for the mushaf font size with a live basmala preview.
class QuranFontSizeControl extends StatelessWidget {
  // Creates the control.
  const QuranFontSizeControl({super.key});

  // Builds the label, preview and slider.
  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<SettingsCubit>();
    final size = cubit.quranFontSize;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: CustomText(text: TextManager.quranFontSize, style: getSemiBoldStyle(context: context)),
            ),
            CustomText(
              text: localizedDigits(context, size.round()),
              translate: false,
              style: getMediumStyle(context: context, color: ColorsManager.secondryDark),
            ),
          ],
        ),
        verticalSpace(8.h),
        CustomText(
          text: TextManager.basmala,
          textAlign: TextAlign.center,
          textDirection: TextDirection.rtl,
          style: getRegularStyle(
            context: context,
            fontSize: size.sp,
            height: 2,
            color: ColorsManager.primary,
            fontFamily: FontManager.quran,
          ),
        ),
        Slider(
          value: size,
          min: SettingsCubit.minFontSize,
          max: SettingsCubit.maxFontSize,
          divisions: (SettingsCubit.maxFontSize - SettingsCubit.minFontSize).round(),
          activeColor: ColorsManager.secondry,
          inactiveColor: ColorsManager.track,
          onChanged: cubit.setQuranFontSize,
        ),
      ],
    );
  }
}
