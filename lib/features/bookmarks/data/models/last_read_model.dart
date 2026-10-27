import 'package:equatable/equatable.dart';

// The last position the reader stopped at.
class LastReadModel extends Equatable {
  final int surahNumber;
  final String surahName;
  final String surahEnglishName;
  final int ayahNumber;
  final int numberOfAyahs;
  final int juz;
  final int page;

  // Creates the last-read model.
  const LastReadModel({
    required this.surahNumber,
    required this.surahName,
    required this.surahEnglishName,
    required this.ayahNumber,
    required this.numberOfAyahs,
    required this.juz,
    required this.page,
  });

  // Parses the model from the local cache.
  factory LastReadModel.fromJson(Map<String, dynamic> json) => LastReadModel(
        surahNumber: json['surahNumber'] as int,
        surahName: json['surahName'] as String,
        surahEnglishName: json['surahEnglishName'] as String? ?? '',
        ayahNumber: json['ayahNumber'] as int,
        numberOfAyahs: json['numberOfAyahs'] as int,
        juz: json['juz'] as int,
        page: json['page'] as int,
      );

  // Serializes the model for the local cache.
  Map<String, dynamic> toJson() => {
        'surahNumber': surahNumber,
        'surahName': surahName,
        'surahEnglishName': surahEnglishName,
        'ayahNumber': ayahNumber,
        'numberOfAyahs': numberOfAyahs,
        'juz': juz,
        'page': page,
      };

  // Builds a placeholder for Skeletonizer loading states.
  factory LastReadModel.dummy() => const LastReadModel(
        surahNumber: 2,
        surahName: 'ٱلْبَقَرَةِ',
        surahEnglishName: 'Al-Baqara',
        ayahNumber: 255,
        numberOfAyahs: 286,
        juz: 3,
        page: 42,
      );

  // Returns how far through the surah the reader is, from 0 to 1.
  double get progress => numberOfAyahs == 0 ? 0 : ayahNumber / numberOfAyahs;

  // Lists the fields used for equality.
  @override
  List<Object?> get props => [surahNumber, ayahNumber, page];
}
