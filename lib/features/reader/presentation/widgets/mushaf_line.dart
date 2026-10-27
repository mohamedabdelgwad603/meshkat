import 'package:flutter/material.dart';
import 'package:mishkat/features/reader/data/models/mushaf_line_model.dart';
import 'package:mishkat/features/reader/data/models/mushaf_model.dart';
import 'package:mishkat/features/reader/presentation/widgets/basmala_line.dart';
import 'package:mishkat/features/reader/presentation/widgets/mushaf_text_line.dart';
import 'package:mishkat/features/reader/presentation/widgets/surah_banner.dart';

// One line of a mushaf page: ayah text, a surah header or the basmala.
class MushafLine extends StatelessWidget {
  final MushafLineModel line;
  final MushafModel mushaf;
  final double fontSize;
  final double lineHeight;
  final double width;
  final bool centered;
  final int? selectedSurah;
  final int? selectedAyah;
  final void Function(int surah, int ayah) onAyahTap;

  // Creates the line.
  const MushafLine({
    super.key,
    required this.line,
    required this.mushaf,
    required this.fontSize,
    required this.lineHeight,
    required this.width,
    required this.onAyahTap,
    this.centered = false,
    this.selectedSurah,
    this.selectedAyah,
  });

  // Builds the widget that matches the line type.
  @override
  Widget build(BuildContext context) {
    switch (line.type) {
      case MushafLineType.surahHeader:
        return SizedBox(
          height: lineHeight,
          child: Center(child: SurahBanner(surah: mushaf.surah(line.surahNumber!), height: lineHeight * 0.88)),
        );
      case MushafLineType.basmala:
        return BasmalaLine(fontSize: fontSize, lineHeight: lineHeight);
      case MushafLineType.text:
        return MushafTextLine(
          line: line,
          fontSize: fontSize,
          lineHeight: lineHeight,
          width: width,
          centered: centered,
          selectedSurah: selectedSurah,
          selectedAyah: selectedAyah,
          onAyahTap: onAyahTap,
        );
    }
  }
}
