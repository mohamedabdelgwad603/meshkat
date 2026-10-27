import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat/config/themes/color_manager.dart';
import 'package:mishkat/config/themes/font_manager.dart';
import 'package:mishkat/config/themes/text_styles.dart';
import 'package:mishkat/core/utills/text_manager.dart';
import 'package:mishkat/core/utills/widgets/custom_text.dart';
import 'package:mishkat/core/utills/widgets/islamic_star_painter.dart';

// Title row of the mushaf index.
class SurahsHeader extends StatelessWidget {
  // Creates the header.
  const SurahsHeader({super.key});

  // Builds the title with a small decorative star.
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CustomText(
            text: TextManager.mushafIndex,
            style: getBoldStyle(
              context: context,
              fontSize: 30.sp,
              color: ColorsManager.primary,
              fontFamily: FontManager.heading,
              height: 1.2,
            ),
          ),
        ),
        IslamicStar(size: 28.r, color: ColorsManager.secondry, strokeWidth: 1.6),
      ],
    );
  }
}
