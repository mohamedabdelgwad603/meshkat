import 'package:equatable/equatable.dart';

// The ayah shown on the home screen for the day.
class DailyAyahModel extends Equatable {
  final String text;
  final int surahNumber;
  final String surahName;
  final String surahEnglishName;
  final int ayahNumber;

  // Creates the daily ayah model.
  const DailyAyahModel({
    required this.text,
    required this.surahNumber,
    required this.surahName,
    required this.surahEnglishName,
    required this.ayahNumber,
  });

  // Parses the ayah from the /ayah endpoint JSON.
  factory DailyAyahModel.fromJson(Map<String, dynamic> json) {
    final surah = json['surah'] as Map<String, dynamic>;
    final name = (surah['name'] as String).trim();
    final parts = name.split(' ');
    return DailyAyahModel(
      text: (json['text'] as String).replaceAll('﻿', '').trim(),
      surahNumber: surah['number'] as int,
      surahName: parts.length > 1 ? parts.sublist(1).join(' ') : name,
      surahEnglishName: surah['englishName'] as String? ?? '',
      ayahNumber: json['numberInSurah'] as int,
    );
  }

  // Parses the ayah from the local cache.
  factory DailyAyahModel.fromCache(Map<String, dynamic> json) => DailyAyahModel(
        text: json['text'] as String,
        surahNumber: json['surahNumber'] as int,
        surahName: json['surahName'] as String,
        surahEnglishName: json['surahEnglishName'] as String? ?? '',
        ayahNumber: json['ayahNumber'] as int,
      );

  // Serializes the ayah for the local cache.
  Map<String, dynamic> toJson() => {
        'text': text,
        'surahNumber': surahNumber,
        'surahName': surahName,
        'surahEnglishName': surahEnglishName,
        'ayahNumber': ayahNumber,
      };

  // Builds a placeholder for Skeletonizer loading states.
  factory DailyAyahModel.dummy() => const DailyAyahModel(
        text: 'أَلَا بِذِكْرِ ٱللَّهِ تَطْمَئِنُّ ٱلْقُلُوبُ',
        surahNumber: 13,
        surahName: 'ٱلرَّعْدِ',
        surahEnglishName: 'Ar-Ra\'d',
        ayahNumber: 28,
      );

  // Lists the fields used for equality.
  @override
  List<Object?> get props => [surahNumber, ayahNumber];
}
