import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat/config/themes/color_manager.dart';
import 'package:mishkat/config/themes/font_manager.dart';
import 'package:mishkat/config/themes/text_styles.dart';
import 'package:mishkat/core/utills/functions/localized_digits.dart';
import 'package:mishkat/core/utills/text_manager.dart';
import 'package:mishkat/core/utills/widgets/custom_text.dart';
import 'package:mishkat/features/reader/data/models/surah_text_model.dart';

// Gold-framed green banner with the surah name, revelation place and ayah count.
class SurahBanner extends StatelessWidget {
  final SurahTextModel surah;

  // Creates the banner for the given surah.
  const SurahBanner({super.key, required this.surah});

  // Builds the double-framed banner.
  @override
  Widget build(BuildContext context) {
    final sideStyle = getRegularStyle(context: context, fontSize: 12.sp, color: ColorsManager.secondry);
    return Container(
      height: 64.h,
      padding: EdgeInsets.all(4.r),
      decoration: BoxDecoration(
        border: Border.all(color: ColorsManager.secondry, width: 1.5),
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        decoration: BoxDecoration(
          color: ColorsManager.primary,
          border: Border.all(color: ColorsManager.goldBorder),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Row(
          children: [
            CustomText(text: surah.isMeccan ? TextManager.meccan : TextManager.medinan, style: sideStyle),
            Expanded(
              child: CustomText(
                text: surah.name,
                translate: false,
                maxLines: 1,
                textAlign: TextAlign.center,
                textDirection: TextDirection.rtl,
                style: getBoldStyle(
                  context: context,
                  fontSize: 22.sp,
                  color: ColorsManager.white,
                  fontFamily: FontManager.heading,
                ),
              ),
            ),
            CustomText(
              text: TextManager.ayahsLabel,
              args: [localizedDigits(context, surah.ayahs.length)],
              style: sideStyle,
            ),
          ],
        ),
      ),
    );
  }
}

