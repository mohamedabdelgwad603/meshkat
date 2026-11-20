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

  // Parses tafsir from the Quran.com /tafsirs/{id}/by_ayah endpoint, turning its HTML into plain paragraphs.
  factory TafsirModel.fromQuranComJson(Map<String, dynamic> json, {required String edition}) {
    final tafsir = json['tafsir'] as Map<String, dynamic>? ?? const {};
    final key = ((tafsir['verses'] as Map<String, dynamic>?)?.keys.firstOrNull ?? '0:0').split(':');
    return TafsirModel(
      edition: edition,
      surahNumber: int.tryParse(key.first) ?? 0,
      ayahNumber: int.tryParse(key.last) ?? 0,
      text: _htmlToText(tafsir['text'] as String? ?? ''),
    );
  }

  // Converts simple HTML paragraphs and spans into plain text with blank lines between paragraphs.
  static String _htmlToText(String html) {
    const entities = {'&nbsp;': ' ', '&quot;': '"', '&#39;': "'", '&lt;': '<', '&gt;': '>', '&amp;': '&'};
    var text = html
        .replaceAll(RegExp(r'<br\s*/?>', caseSensitive: false), '\n')
        .replaceAll(RegExp(r'</p\s*>', caseSensitive: false), '\n\n')
        .replaceAll(RegExp(r'<[^>]+>'), '');
    entities.forEach((entity, value) => text = text.replaceAll(entity, value));
    return text
        .split('\n')
        .map((line) => line.replaceAll(RegExp(r'[ \t]+'), ' ').trim())
        .join('\n')
        .replaceAll(RegExp(r'\n{3,}'), '\n\n')
        .trim();
  }

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
