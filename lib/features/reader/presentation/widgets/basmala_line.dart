import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat/config/themes/color_manager.dart';
import 'package:mishkat/config/themes/font_manager.dart';
import 'package:mishkat/config/themes/text_styles.dart';
import 'package:mishkat/core/utills/text_manager.dart';
import 'package:mishkat/core/utills/widgets/custom_text.dart';

// Centered basmala shown at the start of every surah except Al-Fatiha and At-Tawbah.
class BasmalaLine extends StatelessWidget {
  // Creates the basmala line.
  const BasmalaLine({super.key});

  // Builds the basmala in the Quran font.
  @override
  Widget build(BuildContext context) {
    return CustomText(
      text: TextManager.basmala,
      textAlign: TextAlign.center,
      textDirection: TextDirection.rtl,
      style: getRegularStyle(
        context: context,
        fontSize: 22.sp,
        height: 2,
        color: ColorsManager.primary,
        fontFamily: FontManager.quran,
      ),
    );
  }
}
