import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat/config/themes/color_manager.dart';
import 'package:mishkat/config/themes/font_manager.dart';
import 'package:mishkat/config/themes/text_styles.dart';
import 'package:mishkat/features/mutashabihat/data/models/mutashabih_ayah_model.dart';

// Ayah in the mushaf font with its similar words shaded in gold.
class MutashabihAyahText extends StatelessWidget {
  final MutashabihAyahModel ayah;
  final double fontSize;
  final TextAlign textAlign;

  // Creates the text for the given ayah.
  const MutashabihAyahText({super.key, required this.ayah, this.fontSize = 20, this.textAlign = TextAlign.start});

  // Builds the words as spans, shading the highlighted ones.
  @override
  Widget build(BuildContext context) {
    final style = getRegularStyle(
      context: context,
      fontSize: fontSize.sp,
      height: 2,
      color: ColorsManager.onSurface,
      fontFamily: FontManager.quran,
    );
    final highlighted = style.copyWith(color: ColorsManager.secondryDark, backgroundColor: ColorsManager.goldOverlay);
    final words = ayah.words;
    return Text.rich(
      TextSpan(
        children: [
          for (var i = 0; i < words.length; i++)
            TextSpan(
              text: i < words.length - 1 ? '${words[i]} ' : words[i],
              style: ayah.isHighlighted(i + 1) ? highlighted : style,
            ),
        ],
      ),
      textAlign: textAlign,
      textDirection: TextDirection.rtl,
    );
  }
}
