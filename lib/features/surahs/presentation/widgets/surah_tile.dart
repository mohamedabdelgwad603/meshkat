import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat/config/routes/page_name.dart';
import 'package:mishkat/config/routes/route_arguments.dart';
import 'package:mishkat/config/themes/color_manager.dart';
import 'package:mishkat/config/themes/font_manager.dart';
import 'package:mishkat/config/themes/text_styles.dart';
import 'package:mishkat/core/utills/extentions/build_context_extention.dart';
import 'package:mishkat/core/utills/functions/localized_digits.dart';
import 'package:mishkat/core/utills/functions/spacing.dart';
import 'package:mishkat/core/utills/text_manager.dart';
import 'package:mishkat/core/utills/widgets/custom_text.dart';
import 'package:mishkat/core/utills/widgets/star_number_badge.dart';
import 'package:mishkat/features/surahs/data/models/surah_model.dart';

// One surah row: star number, name, revelation place and ayah count.
class SurahTile extends StatelessWidget {
  final SurahModel surah;

  // Creates the row for the given surah.
  const SurahTile({super.key, required this.surah});

  // Builds the tappable row that opens the reader.
  @override
  Widget build(BuildContext context) {
    final isArabic = context.locale.languageCode == 'ar';
    return InkWell(
      onTap: () => context.pushNamed(PageName.reader, arguments: ReaderArgs(surahNumber: surah.number)),
      child: SizedBox(
        height: 66.h,
        child: Row(
          children: [
            StarNumberBadge(number: surah.number),
            horizontalSpace(14.w),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: TextManager.surahName,
                    args: [surah.displayName(isArabic)],
                    maxLines: 1,
                    style: getBoldStyle(context: context, fontSize: 19.sp, fontFamily: FontManager.heading, height: 1.3),
                  ),
                  CustomText(
                    text: TextManager.ayahsCount,
                    args: [
                      (surah.isMeccan ? TextManager.meccan : TextManager.medinan).tr(context: context),
                      localizedDigits(context, surah.numberOfAyahs),
                    ],
                    style: getRegularStyle(context: context, fontSize: 12.sp, color: ColorsManager.grey),
                  ),
                ],
              ),
            ),
            if (!isArabic)
              CustomText(
                text: surah.shortName,
                translate: false,
                style: getRegularStyle(
                  context: context,
                  fontSize: 18.sp,
                  color: ColorsManager.secondryDark,
                  fontFamily: FontManager.heading,
                ),
              ),
            horizontalSpace(8.w),
            Icon(Icons.arrow_forward_ios_rounded, size: 16.r, color: ColorsManager.mutedOnDark),
          ],
        ),
      ),
    );
  }
}
