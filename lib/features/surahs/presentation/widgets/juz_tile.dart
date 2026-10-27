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
import 'package:mishkat/features/surahs/data/models/juz_model.dart';
import 'package:mishkat/features/surahs/data/models/surah_model.dart';

// One juz row: star number, juz title and where it starts.
class JuzTile extends StatelessWidget {
  final JuzModel juz;
  final SurahModel surah;

  // Creates the row for the given juz and its starting surah.
  const JuzTile({super.key, required this.juz, required this.surah});

  // Builds the tappable row that opens the reader at the juz start.
  @override
  Widget build(BuildContext context) {
    final isArabic = context.locale.languageCode == 'ar';
    return InkWell(
      onTap: () => context.pushNamed(
        PageName.reader,
        arguments: ReaderArgs(surahNumber: juz.surahNumber, initialAyah: juz.ayahNumber),
      ),
      child: SizedBox(
        height: 66.h,
        child: Row(
          children: [
            StarNumberBadge(number: juz.number),
            horizontalSpace(14.w),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: TextManager.juzNumber,
                    args: [localizedDigits(context, juz.number)],
                    style: getBoldStyle(context: context, fontSize: 19.sp, fontFamily: FontManager.heading, height: 1.3),
                  ),
                  CustomText(
                    text: TextManager.juzStart,
                    args: [surah.displayName(isArabic), localizedDigits(context, juz.ayahNumber)],
                    maxLines: 1,
                    style: getRegularStyle(context: context, fontSize: 12.sp, color: ColorsManager.grey),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded, size: 16.r, color: ColorsManager.mutedOnDark),
          ],
        ),
      ),
    );
  }
}
