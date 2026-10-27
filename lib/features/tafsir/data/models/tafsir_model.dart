import 'package:equatable/equatable.dart';

// Tafsir text of one ayah in one edition.
class TafsirModel extends Equatable {
  final String edition;
  final int surahNumber;
  final int ayahNumber;
  final String text;

  // Creates the tafsir model.
  const TafsirModel({required this.edition, required this.surahNumber, required this.ayahNumber, required this.text});

  // Parses tafsir from the /ayah endpoint JSON.
  factory TafsirModel.fromJson(Map<String, dynamic> json) => TafsirModel(
        edition: (json['edition'] as Map<String, dynamic>?)?['identifier'] as String? ?? '',
        surahNumber: (json['surah'] as Map<String, dynamic>?)?['number'] as int? ?? 0,
        ayahNumber: json['numberInSurah'] as int? ?? 0,
        text: (json['text'] as String? ?? '').replaceAll('﻿', '').trim(),
      );

  // Builds a placeholder tafsir for Skeletonizer loading states.
  factory TafsirModel.dummy() => const TafsirModel(
        edition: 'ar.muyassar',
        surahNumber: 1,
        ayahNumber: 2,
        text: 'نص التفسير يظهر هنا بعد التحميل، ويشرح معنى الآية الكريمة بأسلوب واضح ميسر للقارئ، ويمتد على عدة أسطر.',
      );

  // Lists the fields used for equality.
  @override
  List<Object?> get props => [edition, surahNumber, ayahNumber];
}
