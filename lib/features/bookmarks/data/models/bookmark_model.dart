import 'package:equatable/equatable.dart';

// An ayah the user saved.
class BookmarkModel extends Equatable {
  final int surahNumber;
  final String surahName;
  final String surahEnglishName;
  final int ayahNumber;
  final String text;
  final DateTime createdAt;

  // Creates the bookmark model.
  const BookmarkModel({
    required this.surahNumber,
    required this.surahName,
    required this.surahEnglishName,
    required this.ayahNumber,
    required this.text,
    required this.createdAt,
  });

  // Parses the bookmark from the local cache.
  factory BookmarkModel.fromJson(Map<String, dynamic> json) => BookmarkModel(
        surahNumber: json['surahNumber'] as int,
        surahName: json['surahName'] as String,
        surahEnglishName: json['surahEnglishName'] as String? ?? '',
        ayahNumber: json['ayahNumber'] as int,
        text: json['text'] as String,
        createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ?? DateTime.now(),
      );

  // Serializes the bookmark for the local cache.
  Map<String, dynamic> toJson() => {
        'surahNumber': surahNumber,
        'surahName': surahName,
        'surahEnglishName': surahEnglishName,
        'ayahNumber': ayahNumber,
        'text': text,
        'createdAt': createdAt.toIso8601String(),
      };

  // Builds a placeholder for Skeletonizer loading states.
  factory BookmarkModel.dummy() => BookmarkModel(
        surahNumber: 1,
        surahName: 'ٱلْفَاتِحَةِ',
        surahEnglishName: 'Al-Faatiha',
        ayahNumber: 2,
        text: 'ٱلْحَمْدُ لِلَّهِ رَبِّ ٱلْعَـٰلَمِينَ',
        createdAt: DateTime(2026),
      );

  // Tells whether this bookmark points at the given ayah.
  bool matches(int surah, int ayah) => surahNumber == surah && ayahNumber == ayah;

  // Lists the fields used for equality.
  @override
  List<Object?> get props => [surahNumber, ayahNumber];
}
