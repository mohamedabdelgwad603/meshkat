import 'package:flutter_test/flutter_test.dart';
import 'package:mishkat/core/utills/functions/arabic_normalizer.dart';
import 'package:mishkat/features/home/data/requests_params/daily_ayah_params.dart';
import 'package:mishkat/features/reader/data/models/surah_text_model.dart';

// Unit tests for search normalization, basmala stripping and the daily ayah picker.
void main() {
  test('normalizeArabic ignores diacritics and alif forms', () {
    expect(normalizeArabic('ٱلْفَاتِحَةِ'), normalizeArabic('الفاتحه'));
    expect(toWesternDigits('١١٤'), '114');
  });

  test('basmala is removed from the first ayah of Al-Baqarah only', () {
    final baqarah = SurahTextModel.fromJson({
      'number': 2,
      'name': 'سُورَةُ البَقَرَةِ',
      'englishName': 'Al-Baqara',
      'revelationType': 'Medinan',
      'ayahs': [
        {'number': 8, 'numberInSurah': 1, 'text': 'بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ الٓمٓ', 'juz': 1, 'page': 2},
      ],
    });
    expect(baqarah.ayahs.first.text, 'الٓمٓ');

    final fatiha = SurahTextModel.fromJson({
      'number': 1,
      'name': 'سُورَةُ ٱلْفَاتِحَةِ',
      'englishName': 'Al-Faatiha',
      'revelationType': 'Meccan',
      'ayahs': [
        {'number': 1, 'numberInSurah': 1, 'text': '﻿بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ', 'juz': 1, 'page': 1},
      ],
    });
    expect(fatiha.ayahs.first.text.startsWith('بِسْمِ'), isTrue);
  });

  test('daily ayah number stays within the Quran', () {
    for (var day = 0; day < 1000; day++) {
      final n = DailyAyahParams(dayIndex: day).ayahNumber;
      expect(n, inInclusiveRange(1, 6236));
    }
  });
}
