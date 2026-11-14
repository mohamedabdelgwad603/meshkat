import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat/config/themes/color_manager.dart';
import 'package:mishkat/config/themes/font_manager.dart';
import 'package:mishkat/config/themes/text_styles.dart';
import 'package:mishkat/core/utills/functions/localized_digits.dart';
import 'package:mishkat/core/utills/functions/spacing.dart';
import 'package:mishkat/core/utills/text_manager.dart';
import 'package:mishkat/core/utills/widgets/custom_text.dart';

// Soft framed quote of an ayah with its surah and number.
class ReflectionAyahQuote extends StatelessWidget {
  final String surahName;
  final int ayahNumber;
  final String ayahText;
  final int maxLines;

  // Creates the quote.
  const ReflectionAyahQuote({
    super.key,
    required this.surahName,
    required this.ayahNumber,
    required this.ayahText,
    this.maxLines = 2,
  });

  // Builds the reference line and the ayah text in the mushaf font.
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsetsDirectional.fromSTEB(14.w, 10.h, 14.w, 10.h),
      decoration: BoxDecoration(
        color: ColorsManager.primaryLight,
        borderRadius: BorderRadius.circular(16.r),
        border: BorderDirectional(start: BorderSide(color: ColorsManager.secondry, width: 3.w)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomText(
            text: TextManager.surahAyahRef,
            args: [surahName, localizedDigits(context, ayahNumber)],
            style: getSemiBoldStyle(context: context, fontSize: 12.sp, color: ColorsManager.secondryDark),
          ),
          verticalSpace(4.h),
          CustomText(
            text: ayahText,
            translate: false,
            maxLines: maxLines,
            overflow: TextOverflow.ellipsis,
            textDirection: TextDirection.rtl,
            style: getRegularStyle(
              context: context,
              fontSize: 18.sp,
              height: 1.9,
              color: ColorsManager.primary,
              fontFamily: FontManager.quran,
            ),
          ),
        ],
      ),
    );
  }
}
