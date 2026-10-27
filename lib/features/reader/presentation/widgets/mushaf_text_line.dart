import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mishkat/config/themes/color_manager.dart';
import 'package:mishkat/config/themes/font_manager.dart';
import 'package:mishkat/config/themes/text_styles.dart';
import 'package:mishkat/core/utills/functions/kashida.dart';
import 'package:mishkat/features/reader/data/models/mushaf_line_model.dart';
import 'package:mishkat/features/reader/data/models/mushaf_word_model.dart';

// Returns the base Quran text style for a mushaf line, without the theme's letter spacing so measured widths stay exact.
TextStyle mushafLineStyle(BuildContext context, double fontSize, double lineHeight) => getRegularStyle(
      context: context,
      fontSize: fontSize,
      height: lineHeight / fontSize,
      fontFamily: FontManager.quran,
    ).copyWith(letterSpacing: 0, wordSpacing: 0);

// Measures the natural width of a line's words separated by single spaces.
double measureMushafLine(MushafLineModel line, TextStyle style) {
  final painter = TextPainter(
    text: TextSpan(text: line.words.map((w) => w.text).join(' '), style: style),
    textDirection: TextDirection.rtl,
    textScaler: TextScaler.noScaling,
    maxLines: 1,
  )..layout();
  final width = painter.width;
  painter.dispose();
  return width;
}

// Width left free at the line end, relative to the font size, so shaping and rounding never push the last word out.
const double _safetyMarginRatio = 0.35;

// Smallest gap between words on a long line, as a share of a normal space.
const double _minSpaceShare = 0.3;

// Most tatweels added at one join, so a stretched word keeps its shape.
const int _maxKashidaPerWord = 6;

// Widest gap between words, relative to the font size, before a short line is centered instead of stretched.
const double _maxGapRatio = 1.2;

// Extra gap between words on a centered short line, relative to the font size.
const double _shortLineGapRatio = 0.35;

// Measures the width of a single piece of text in the given style.
double _measureText(String text, TextStyle style) {
  final painter = TextPainter(
    text: TextSpan(text: text, style: style),
    textDirection: TextDirection.rtl,
    textScaler: TextScaler.noScaling,
    maxLines: 1,
  )..layout();
  final width = painter.width;
  painter.dispose();
  return width;
}

// Measures the natural width of the given word texts separated by single spaces.
double _measureWords(List<String> texts, TextStyle style) => _measureText(texts.join(' '), style);

// How a line is filled: the word texts with any kashida, the gap between words and how it is placed.
class _LineFill {
  final List<String> texts;
  final double spacing;
  final bool centered;
  final bool shrink;

  // Creates the fill.
  const _LineFill(this.texts, this.spacing, {this.centered = false, this.shrink = false});
}

// Fills a line to the width like the printed mushaf: tightens spaces on long lines and stretches joins with kashida on short ones.
_LineFill _fillLine(List<MushafWordModel> words, TextStyle style, double width, double fontSize) {
  final texts = [for (final w in words) w.text];
  final gaps = texts.length - 1;
  final margin = fontSize * _safetyMarginRatio;
  final room = width - _measureWords(texts, style) - margin;
  if (gaps <= 0) return _LineFill(texts, 0, centered: true);
  if (room < 0) {
    final minSpacing = -_measureText(' ', style) * (1 - _minSpaceShare);
    final spacing = room / gaps;
    return spacing >= minSpacing ? _LineFill(texts, spacing) : _LineFill(texts, minSpacing, shrink: true);
  }
  final stretched = _addKashida(words, texts, room, _measureText(tatweel, style));
  final spacing = (width - _measureWords(stretched, style) - margin) / gaps;
  if (spacing > fontSize * _maxGapRatio) {
    return _LineFill(texts, min(room / gaps, fontSize * _shortLineGapRatio), centered: true);
  }
  return _LineFill(stretched, spacing);
}

// Spreads as many tatweels as fit in the free room over the words' last joins, stretching every other word first.
List<String> _addKashida(List<MushafWordModel> words, List<String> texts, double room, double tatweelWidth) {
  if (tatweelWidth <= 0) return texts;
  final positions = [for (final w in words) w.isAyahEnd ? const <int>[] : kashidaPositions(w.text)];
  final counts = [for (final _ in words) <int, int>{}];
  final stretchable = [for (var i = 0; i < words.length; i++) if (positions[i].isNotEmpty) i];
  final firstPass = [for (var k = 0; k < stretchable.length; k += 2) stretchable[k]];
  var left = (room / tatweelWidth).floor();
  for (final group in [firstPass, stretchable]) {
    for (var round = 0; left > 0 && group.isNotEmpty; round++) {
      var added = false;
      for (final i in group) {
        final at = positions[i].first;
        if (left == 0 || (counts[i][at] ?? 0) >= _maxKashidaPerWord) continue;
        counts[i][at] = (counts[i][at] ?? 0) + 1;
        left--;
        added = true;
      }
      if (!added) break;
    }
  }
  return [for (var i = 0; i < texts.length; i++) insertKashida(texts[i], counts[i])];
}

// One printed line of ayah text, stretched to the full width like the mushaf, with tappable ayahs.
class MushafTextLine extends StatefulWidget {
  final MushafLineModel line;
  final double fontSize;
  final double lineHeight;
  final double width;
  final bool centered;
  final int? selectedSurah;
  final int? selectedAyah;
  final void Function(int surah, int ayah) onAyahTap;

  // Creates the line.
  const MushafTextLine({
    super.key,
    required this.line,
    required this.fontSize,
    required this.lineHeight,
    required this.width,
    required this.onAyahTap,
    this.centered = false,
    this.selectedSurah,
    this.selectedAyah,
  });

  // Creates the state that owns the tap recognizers.
  @override
  State<MushafTextLine> createState() => _MushafTextLineState();
}

// Keeps one tap recognizer per ayah on the line and disposes them with the widget.
class _MushafTextLineState extends State<MushafTextLine> {
  final Map<int, TapGestureRecognizer> _recognizers = {};

  // Releases every recognizer.
  @override
  void dispose() {
    for (final r in _recognizers.values) {
      r.dispose();
    }
    super.dispose();
  }

  // Returns the recognizer of an ayah, creating it on first use.
  TapGestureRecognizer _recognizerFor(MushafWordModel word) => _recognizers.putIfAbsent(
        word.surah * 1000 + word.ayah,
        () => TapGestureRecognizer()..onTap = () => widget.onAyahTap(word.surah, word.ayah),
      );

  // Tells whether the word belongs to the selected ayah.
  bool _isSelected(MushafWordModel word) => word.surah == widget.selectedSurah && word.ayah == widget.selectedAyah;

  // Builds the line filled to the full width, shrinking the rare line that is still too long.
  @override
  Widget build(BuildContext context) {
    final words = widget.line.words;
    final base = mushafLineStyle(context, widget.fontSize, widget.lineHeight);
    final fill = widget.centered
        ? _LineFill([for (final w in words) w.text], 0, centered: true)
        : _fillLine(words, base, widget.width, widget.fontSize);
    final style = base.copyWith(wordSpacing: fill.spacing);
    final markerStyle = style.copyWith(color: ColorsManager.secondryDark);
    final gaps = words.length - 1;
    final text = Text.rich(
      TextSpan(
        children: [
          for (var i = 0; i < words.length; i++)
            TextSpan(
              text: i < gaps ? '${fill.texts[i]} ' : fill.texts[i],
              style: (words[i].isAyahEnd ? markerStyle : style).copyWith(
                backgroundColor: _isSelected(words[i]) ? ColorsManager.goldOverlay : null,
              ),
              recognizer: _recognizerFor(words[i]),
            ),
        ],
      ),
      textAlign: fill.centered ? TextAlign.center : TextAlign.start,
      textDirection: TextDirection.rtl,
      textScaler: TextScaler.noScaling,
      maxLines: 1,
      softWrap: false,
    );
    return SizedBox(
      width: widget.width,
      height: widget.lineHeight,
      child: fill.shrink ? FittedBox(fit: BoxFit.scaleDown, child: text) : text,
    );
  }
}
