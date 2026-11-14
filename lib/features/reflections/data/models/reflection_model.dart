import 'package:equatable/equatable.dart';

// A personal reflection the user wrote on one ayah.
class ReflectionModel extends Equatable {
  final int surahNumber;
  final String surahName;
  final String surahEnglishName;
  final int ayahNumber;
  final String ayahText;
  final String note;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Creates the reflection model.
  const ReflectionModel({
    required this.surahNumber,
    required this.surahName,
    required this.surahEnglishName,
    required this.ayahNumber,
    required this.ayahText,
    required this.note,
    required this.createdAt,
    required this.updatedAt,
  });

  // Parses the reflection from the local cache.
  factory ReflectionModel.fromJson(Map<String, dynamic> json) {
    final createdAt = DateTime.tryParse(json['createdAt'] as String? ?? '') ?? DateTime.now();
    return ReflectionModel(
      surahNumber: json['surahNumber'] as int,
      surahName: json['surahName'] as String? ?? '',
      surahEnglishName: json['surahEnglishName'] as String? ?? '',
      ayahNumber: json['ayahNumber'] as int,
      ayahText: json['ayahText'] as String? ?? '',
      note: json['note'] as String? ?? '',
      createdAt: createdAt,
      updatedAt: DateTime.tryParse(json['updatedAt'] as String? ?? '') ?? createdAt,
    );
  }

  // Serializes the reflection for the local cache.
  Map<String, dynamic> toJson() => {
        'surahNumber': surahNumber,
        'surahName': surahName,
        'surahEnglishName': surahEnglishName,
        'ayahNumber': ayahNumber,
        'ayahText': ayahText,
        'note': note,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };

  // Builds a placeholder for Skeletonizer loading states.
  factory ReflectionModel.dummy() => ReflectionModel(
        surahNumber: 1,
        surahName: 'ٱلْفَاتِحَةِ',
        surahEnglishName: 'Al-Faatiha',
        ayahNumber: 5,
        ayahText: 'إِيَّاكَ نَعۡبُدُ وَإِيَّاكَ نَسۡتَعِينُ',
        note: 'خاطرة قصيرة عن معنى الآية وما استوقفني فيها أثناء القراءة.',
        createdAt: DateTime(2026),
        updatedAt: DateTime(2026),
      );

  // Tells whether this reflection belongs to the given ayah.
  bool matches(int surah, int ayah) => surahNumber == surah && ayahNumber == ayah;

  // Lists the fields used for equality.
  @override
  List<Object?> get props => [surahNumber, ayahNumber, note, updatedAt];
}
