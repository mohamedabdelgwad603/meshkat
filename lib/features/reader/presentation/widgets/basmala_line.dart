import 'package:flutter/material.dart';
import 'package:mishkat/config/themes/color_manager.dart';
import 'package:mishkat/config/themes/font_manager.dart';
import 'package:mishkat/config/themes/text_styles.dart';
import 'package:mishkat/core/utills/text_manager.dart';
import 'package:mishkat/core/utills/widgets/custom_text.dart';

// Centered basmala line shown at the start of every surah except Al-Fatiha and At-Tawbah.
class BasmalaLine extends StatelessWidget {
  final double fontSize;
  final double lineHeight;

  // Creates the basmala line at the page's font size and line height.
  const BasmalaLine({super.key, required this.fontSize, required this.lineHeight});

  // Builds the basmala in the Quran font.
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: lineHeight,
      child: Center(
        child: CustomText(
          text: TextManager.basmala,
          textAlign: TextAlign.center,
          textDirection: TextDirection.rtl,
          maxLines: 1,
          style: getRegularStyle(
            context: context,
            fontSize: fontSize,
            height: lineHeight / fontSize,
            color: ColorsManager.primary,
            fontFamily: FontManager.quran,
          ),
        ),
      ),
    );
  }
}
