// A surah's name, revelation place and ayah count, used for headers and titles in the mushaf.
class MushafSurahModel {
  final int number;
  final String name;
  final String englishName;
  final bool isMeccan;
  final int ayahCount;

  // Creates the surah info.
  const MushafSurahModel({
    required this.number,
    required this.name,
    required this.englishName,
    required this.isMeccan,
    required this.ayahCount,
  });

  // Parses the surah from the bundled page layout JSON.
  factory MushafSurahModel.fromJson(Map<String, dynamic> json, int number) => MushafSurahModel(
        number: number,
        name: (json['name'] as String).trim(),
        englishName: json['englishName'] as String? ?? '',
        isMeccan: json['isMeccan'] as bool? ?? true,
        ayahCount: json['ayahs'] as int,
      );

  // Builds a placeholder surah for Skeletonizer loading states.
  factory MushafSurahModel.dummy() => const MushafSurahModel(
        number: 1,
        name: 'سُورَةُ ٱلْفَاتِحَةِ',
        englishName: 'Al-Faatiha',
        isMeccan: true,
        ayahCount: 7,
      );

  // Returns the name without the leading word "سورة".
  String get shortName {
    final parts = name.split(' ');
    return parts.length > 1 ? parts.sublist(1).join(' ') : name;
  }
}
