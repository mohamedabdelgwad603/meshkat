import 'package:equatable/equatable.dart';

// Metadata of one surah as returned by the /surah endpoint.
class SurahModel extends Equatable {
  final int number;
  final String name;
  final String englishName;
  final String englishNameTranslation;
  final int numberOfAyahs;
  final bool isMeccan;

  // Creates a surah model.
  const SurahModel({
    required this.number,
    required this.name,
    required this.englishName,
    required this.englishNameTranslation,
    required this.numberOfAyahs,
    required this.isMeccan,
  });

  // Parses a surah from the API JSON.
  factory SurahModel.fromJson(Map<String, dynamic> json) => SurahModel(
        number: json['number'] as int,
        name: (json['name'] as String).trim(),
        englishName: json['englishName'] as String? ?? '',
        englishNameTranslation: json['englishNameTranslation'] as String? ?? '',
        numberOfAyahs: json['numberOfAyahs'] as int,
        isMeccan: (json['revelationType'] as String? ?? 'Meccan') == 'Meccan',
      );

  // Serializes the surah for the local cache.
  Map<String, dynamic> toJson() => {
        'number': number,
        'name': name,
        'englishName': englishName,
        'englishNameTranslation': englishNameTranslation,
        'numberOfAyahs': numberOfAyahs,
        'revelationType': isMeccan ? 'Meccan' : 'Medinan',
      };

  // Builds a placeholder surah for Skeletonizer loading states.
  factory SurahModel.dummy() => const SurahModel(
        number: 1,
        name: 'سُورَةُ ٱلْفَاتِحَةِ',
        englishName: 'Al-Faatiha',
        englishNameTranslation: 'The Opening',
        numberOfAyahs: 7,
        isMeccan: true,
      );

  // Returns the name without the leading word "سورة".
  String get shortName {
    final parts = name.split(' ');
    return parts.length > 1 ? parts.sublist(1).join(' ') : name;
  }

  // Returns the name suited to the current language.
  String displayName(bool isArabic) => isArabic ? shortName : englishName;

  // Lists the fields used for equality.
  @override
  List<Object?> get props => [number];
}
