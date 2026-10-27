import 'package:flutter/material.dart';
import 'package:mishkat/config/themes/color_manager.dart';
import 'package:mishkat/config/themes/font_manager.dart';
import 'package:mishkat/config/themes/text_styles.dart';
import 'package:mishkat/core/utills/functions/localized_digits.dart';
import 'package:mishkat/core/utills/text_manager.dart';
import 'package:mishkat/core/utills/widgets/custom_text.dart';
import 'package:mishkat/features/reader/data/models/mushaf_surah_model.dart';

// Gold-framed green surah header that fills one mushaf line, with the revelation place and ayah count.
class SurahBanner extends StatelessWidget {
  final MushafSurahModel surah;
  final double height;

  // Creates the banner at the given height; sizes inside it follow the height since it is already screen-fitted.
  const SurahBanner({super.key, required this.surah, required this.height});

  // Builds the double-framed banner.
  @override
  Widget build(BuildContext context) {
    final sideStyle = getRegularStyle(context: context, fontSize: height * 0.24, color: ColorsManager.secondry, height: 1);
    return Container(
      height: height,
      padding: EdgeInsets.all(height * 0.06),
      decoration: BoxDecoration(
        border: Border.all(color: ColorsManager.secondry, width: 1.5),
        borderRadius: BorderRadius.circular(height * 0.22),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: height * 0.3),
        decoration: BoxDecoration(
          color: ColorsManager.primary,
          border: Border.all(color: ColorsManager.goldBorder),
          borderRadius: BorderRadius.circular(height * 0.16),
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
                  fontSize: height * 0.42,
                  color: ColorsManager.white,
                  fontFamily: FontManager.heading,
                  height: 1.2,
                ),
              ),
            ),
            CustomText(
              text: TextManager.ayahsLabel,
              args: [localizedDigits(context, surah.ayahCount)],
              style: sideStyle,
            ),
          ],
        ),
      ),
    );
  }
}
