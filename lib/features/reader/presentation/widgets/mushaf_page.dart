import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat/config/themes/color_manager.dart';
import 'package:mishkat/config/themes/text_styles.dart';
import 'package:mishkat/core/utills/functions/localized_digits.dart';
import 'package:mishkat/core/utills/widgets/custom_text.dart';
import 'package:mishkat/features/reader/data/models/mushaf_model.dart';
import 'package:mishkat/features/reader/data/models/mushaf_page_model.dart';
import 'package:mishkat/features/reader/presentation/widgets/mushaf_line.dart';

// Number of lines on a printed Madani mushaf page.
const int _linesPerPage = 15;

// Font size to line height ratio that leaves room for the stacked marks of the mushaf font.
const double _lineHeightRatio = 1.8;

// Width at font size 100 of nineteen in twenty lines of the mushaf once their spaces are tightened to half; longer lines tighten further.
const double _referenceLineWidth = 1800;

// One mushaf page fitted to the screen: its fifteen printed lines and the page number.
class MushafPage extends StatelessWidget {
  final MushafPageModel page;
  final MushafModel mushaf;
  final int? selectedSurah;
  final int? selectedAyah;
  final void Function(int surah, int ayah) onAyahTap;

  // Creates the page.
  const MushafPage({
    super.key,
    required this.page,
    required this.mushaf,
    required this.onAyahTap,
    this.selectedSurah,
    this.selectedAyah,
  });

  // Builds the lines at one font size shared by every page, ignoring the system text scale so the page always fits.
  @override
  Widget build(BuildContext context) {
    return MediaQuery.withNoTextScaling(
      child: Padding(
        padding: EdgeInsets.fromLTRB(6.w, 4.h, 6.w, 6.h + MediaQuery.paddingOf(context).bottom),
        child: Column(
          children: [
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final lineHeight = constraints.maxHeight / _linesPerPage;
                  final fontSize = min(
                    lineHeight / _lineHeightRatio,
                    100 * (constraints.maxWidth - 4) / _referenceLineWidth,
                  );
                  return Column(
                    mainAxisAlignment: page.isOpening ? MainAxisAlignment.center : MainAxisAlignment.start,
                    children: [
                      for (final line in page.lines)
                        MushafLine(
                          line: line,
                          mushaf: mushaf,
                          fontSize: fontSize,
                          lineHeight: lineHeight,
                          width: constraints.maxWidth,
                          centered: page.isOpening,
                          selectedSurah: selectedSurah,
                          selectedAyah: selectedAyah,
                          onAyahTap: onAyahTap,
                        ),
                    ],
                  );
                },
              ),
            ),
            CustomText(
              text: localizedDigits(context, page.number),
              translate: false,
              style: getMediumStyle(context: context, fontSize: 12.sp, color: ColorsManager.grey),
            ),
          ],
        ),
      ),
    );
  }
}
