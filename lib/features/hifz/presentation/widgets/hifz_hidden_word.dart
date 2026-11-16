import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat/config/themes/color_manager.dart';

// Rounded blank roughly as wide as the hidden word, so the ayah keeps its shape.
class HifzHiddenWord extends StatelessWidget {
  final String word;

  // Creates the blank for the given word.
  const HifzHiddenWord({super.key, required this.word});

  // Builds the blank sized from the word's letters.
  @override
  Widget build(BuildContext context) {
    final letters = word.replaceAll(RegExp(r'[ؐ-ًؚ-ٰٟۖ-ۭـ]'), '').length;
    return Container(
      width: (letters * 8.0).clamp(18.0, 96.0).w,
      height: 22.h,
      margin: EdgeInsets.symmetric(vertical: 6.h),
      decoration: BoxDecoration(color: ColorsManager.track, borderRadius: BorderRadius.circular(8.r)),
    );
  }
}
