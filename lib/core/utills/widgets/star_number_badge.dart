import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat/config/themes/color_manager.dart';
import 'package:mishkat/config/themes/text_styles.dart';
import 'package:mishkat/core/utills/functions/localized_digits.dart';
import 'package:mishkat/core/utills/widgets/custom_text.dart';
import 'package:mishkat/core/utills/widgets/islamic_star_painter.dart';

// Shows a number centered inside a gold eight-point star, used for surah and juz indexes.
class StarNumberBadge extends StatelessWidget {
  final int number;
  final double size;

  // Creates a badge for the given number.
  const StarNumberBadge({super.key, required this.number, this.size = 42});

  // Builds the star outline with the localized number on top.
  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size.r,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size.square(size.r),
            painter: IslamicStarPainter(color: ColorsManager.secondry, strokeWidth: 1.6, cornerRadius: 2.r),
          ),
          CustomText(
            text: localizedDigits(context, number),
            translate: false,
            style: getBoldStyle(context: context, fontSize: 12.sp, color: ColorsManager.primary),
          ),
        ],
      ),
    );
  }
}
