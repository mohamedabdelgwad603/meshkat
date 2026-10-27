import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mishkat/core/utills/functions/kashida.dart';

// Temporary check that no word holding the name of Allah or a lam-alef gets a kashida.
void main() {
  // Scans every word of the mushaf.
  test('kashida positions', () {
    final data = jsonDecode(File('assets/quran/mushaf_pages.json').readAsStringSync()) as Map<String, dynamic>;
    var allah = 0, allahStretched = 0, words = 0, stretchable = 0;
    for (final page in data['pages'] as List) {
      for (final line in (page as Map)['lines'] as List) {
        for (final w in ((line as Map)['words'] as List?) ?? const []) {
          final text = (w as Map)['t'] as String;
          words++;
          final positions = kashidaPositions(text);
          if (positions.isNotEmpty) stretchable++;
          final bare = text.replaceAll(RegExp('[ً-ٰٟۖ-ۭ]'), '');
          if (bare.contains('لله')) {
            allah++;
            if (positions.isNotEmpty) allahStretched++;
          }
          for (final p in positions) {
            final before = text.substring(0, p).replaceAll(RegExp('[ً-ٰٟۖ-ۭ]'), '');
            expect(before.endsWith('ل') && 'اأإآٱ'.contains(text[p]), isFalse, reason: text);
          }
        }
      }
    }
    // ignore: avoid_print
    print('words $words, stretchable $stretchable, with Allah $allah, Allah stretched $allahStretched');
  });
}
