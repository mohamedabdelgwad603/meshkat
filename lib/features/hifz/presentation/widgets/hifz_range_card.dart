import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat/config/themes/color_manager.dart';
import 'package:mishkat/config/themes/text_styles.dart';
import 'package:mishkat/core/utills/functions/localized_digits.dart';
import 'package:mishkat/core/utills/functions/spacing.dart';
import 'package:mishkat/core/utills/text_manager.dart';
import 'package:mishkat/core/utills/widgets/custom_text.dart';
import 'package:mishkat/features/hifz/presentation/cubit/hifz_setup_cubit.dart';
import 'package:mishkat/features/hifz/presentation/widgets/hifz_setup_selector.dart';
import 'package:mishkat/features/hifz/presentation/widgets/hifz_stepper.dart';
import 'package:mishkat/features/hifz/presentation/widgets/hifz_surah_picker_sheet.dart';
import 'package:mishkat/features/settings/presentation/widgets/settings_card.dart';
import 'package:mishkat/features/settings/presentation/widgets/settings_link_tile.dart';

// Card for choosing the surah and the first and last ayah of the range.
class HifzRangeCard extends StatelessWidget {
  // Creates the card.
  const HifzRangeCard({super.key});

  // Builds the surah row, the two steppers and the range length.
  @override
  Widget build(BuildContext context) {
    final isArabic = context.locale.languageCode == 'ar';
    return HifzSetupSelector(
      builder: (context, data) {
        final cubit = HifzSetupCubit.get(context);
        return SettingsCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SettingsLinkTile(
                icon: Icons.menu_book_outlined,
                title: TextManager.hifzSurah,
                value: isArabic ? data.surah.shortName : data.surah.englishName,
                onTap: () async {
                  final picked = await showHifzSurahPicker(context, surahs: data.surahs, selected: data.surah.number);
                  if (picked != null && context.mounted) cubit.selectSurah(picked);
                },
              ),
              Divider(height: 20.h, color: ColorsManager.greyLight),
              Row(
                children: [
                  Expanded(
                    child: HifzStepper(
                      label: TextManager.hifzFrom,
                      value: data.fromAyah,
                      min: 1,
                      max: data.surah.ayahCount,
                      onChanged: cubit.setFrom,
                    ),
                  ),
                  horizontalSpace(10.w),
                  Expanded(
                    child: HifzStepper(
                      label: TextManager.hifzTo,
                      value: data.toAyah,
                      min: 1,
                      max: data.surah.ayahCount,
                      onChanged: cubit.setTo,
                    ),
                  ),
                ],
              ),
              verticalSpace(10.h),
              CustomText(
                text: TextManager.hifzRangeLength,
                args: [localizedDigits(context, data.rangeLength)],
                textAlign: TextAlign.center,
                style: getMediumStyle(context: context, fontSize: 12.sp, color: ColorsManager.grey),
              ),
            ],
          ),
        );
      },
    );
  }
}
