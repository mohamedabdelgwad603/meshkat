import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat/config/routes/page_name.dart';
import 'package:mishkat/config/routes/route_arguments.dart';
import 'package:mishkat/config/themes/color_manager.dart';
import 'package:mishkat/config/themes/text_styles.dart';
import 'package:mishkat/core/utills/extentions/build_context_extention.dart';
import 'package:mishkat/core/utills/functions/localized_digits.dart';
import 'package:mishkat/core/utills/functions/spacing.dart';
import 'package:mishkat/core/utills/text_manager.dart';
import 'package:mishkat/core/utills/widgets/custom_text.dart';
import 'package:mishkat/features/mutashabihat/data/models/mutashabih_ayah_model.dart';
import 'package:mishkat/features/mutashabihat/presentation/widgets/mutashabih_ayah_text.dart';

// Another ayah containing the phrase, which opens in the mushaf when tapped.
class MutashabihOccurrenceTile extends StatelessWidget {
  final MutashabihAyahModel ayah;

  // Creates the tile for the given ayah.
  const MutashabihOccurrenceTile({super.key, required this.ayah});

  // Builds the reference line and the ayah with the phrase shaded.
  @override
  Widget build(BuildContext context) {
    final isArabic = context.locale.languageCode == 'ar';
    return InkWell(
      borderRadius: BorderRadius.circular(14.r),
      onTap: () => context.pushNamed(
        PageName.reader,
        arguments: ReaderArgs(surahNumber: ayah.surahNumber, initialAyah: ayah.ayahNumber),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 8.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: CustomText(
                    text: TextManager.surahAyahRef,
                    args: [ayah.displaySurah(isArabic), localizedDigits(context, ayah.ayahNumber)],
                    style: getSemiBoldStyle(context: context, fontSize: 12.sp, color: ColorsManager.primary),
                  ),
                ),
                Icon(Icons.menu_book_rounded, size: 16.r, color: ColorsManager.grey),
              ],
            ),
            verticalSpace(2.h),
            MutashabihAyahText(ayah: ayah, fontSize: 18),
          ],
        ),
      ),
    );
  }
}
