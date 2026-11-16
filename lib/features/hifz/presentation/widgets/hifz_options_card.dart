import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat/config/themes/color_manager.dart';
import 'package:mishkat/config/themes/text_styles.dart';
import 'package:mishkat/core/utills/functions/localized_digits.dart';
import 'package:mishkat/core/utills/functions/spacing.dart';
import 'package:mishkat/core/utills/text_manager.dart';
import 'package:mishkat/core/utills/widgets/custom_text.dart';
import 'package:mishkat/features/hifz/data/models/hifz_settings_model.dart';
import 'package:mishkat/features/hifz/presentation/cubit/hifz_setup_cubit.dart';
import 'package:mishkat/features/hifz/presentation/widgets/hifz_choice_chips.dart';
import 'package:mishkat/features/hifz/presentation/widgets/hifz_setup_selector.dart';
import 'package:mishkat/features/settings/presentation/widgets/settings_card.dart';

// Card with the repeat counts, the recite pause switch and the speed.
class HifzOptionsCard extends StatelessWidget {
  // Creates the card.
  const HifzOptionsCard({super.key});

  // Builds the four options from the current settings.
  @override
  Widget build(BuildContext context) {
    return HifzSetupSelector(
      builder: (context, data) {
        final settings = data.settings;
        final cubit = HifzSetupCubit.get(context);
        return SettingsCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              HifzChoiceChips<int>(
                title: TextManager.hifzAyahRepeat,
                options: HifzSettingsModel.ayahRepeatOptions,
                selected: settings.ayahRepeat,
                labelOf: (n) => '${localizedDigits(context, n)}×',
                onSelected: (n) => cubit.updateSettings(settings.copyWith(ayahRepeat: n)),
              ),
              Divider(height: 28.h, color: ColorsManager.greyLight),
              HifzChoiceChips<int>(
                title: TextManager.hifzRangeRepeat,
                hint: TextManager.hifzRangeRepeatHint,
                options: HifzSettingsModel.rangeRepeatOptions,
                selected: settings.rangeRepeat,
                labelOf: (n) => n == 0 ? TextManager.hifzOff.tr(context: context) : '${localizedDigits(context, n)}×',
                onSelected: (n) => cubit.updateSettings(settings.copyWith(rangeRepeat: n)),
              ),
              Divider(height: 28.h, color: ColorsManager.greyLight),
              _buildRecitePause(context, settings, cubit),
              Divider(height: 28.h, color: ColorsManager.greyLight),
              HifzChoiceChips<double>(
                title: TextManager.hifzSpeed,
                options: HifzSettingsModel.speedOptions,
                selected: settings.speed,
                labelOf: (s) => '${localizedDigits(context, _formatSpeed(s))}×',
                onSelected: (s) => cubit.updateSettings(settings.copyWith(speed: s)),
              ),
            ],
          ),
        );
      },
    );
  }

  // Builds the recite pause title, explanation and switch.
  Widget _buildRecitePause(BuildContext context, HifzSettingsModel settings, HifzSetupCubit cubit) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomText(text: TextManager.hifzRecitePause, style: getSemiBoldStyle(context: context, fontSize: 14.sp)),
              verticalSpace(2.h),
              CustomText(
                text: TextManager.hifzRecitePauseHint,
                style: getRegularStyle(context: context, fontSize: 12.sp, color: ColorsManager.grey),
              ),
            ],
          ),
        ),
        horizontalSpace(8.w),
        Switch.adaptive(
          value: settings.recitePause,
          activeTrackColor: ColorsManager.primary,
          onChanged: (value) => cubit.updateSettings(settings.copyWith(recitePause: value)),
        ),
      ],
    );
  }

  // Formats the speed without trailing zeros.
  String _formatSpeed(double speed) =>
      speed == speed.roundToDouble() ? speed.toStringAsFixed(0) : speed.toString().replaceAll(RegExp(r'0+$'), '');
}
