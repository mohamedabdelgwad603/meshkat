import 'package:equatable/equatable.dart';
import 'package:mishkat/features/reader/data/models/ayah_model.dart';
import 'package:mishkat/features/reader/data/models/mushaf_ayah_model.dart';

// A full surah's text: its metadata plus every ayah, with the basmala split out.
class SurahTextModel extends Equatable {
  final int number;
  final String name;
  final String englishName;
  final bool isMeccan;
  final List<AyahModel> ayahs;

  // Creates the surah text model.
  const SurahTextModel({
    required this.number,
    required this.name,
    required this.englishName,
    required this.isMeccan,
    required this.ayahs,
  });

  // Parses the surah from the API JSON and removes the basmala from the first ayah when it is not an ayah itself.
  factory SurahTextModel.fromJson(Map<String, dynamic> json) {
    final number = json['number'] as int;
    final ayahs = (json['ayahs'] as List<dynamic>)
        .map((e) => AyahModel.fromJson(e as Map<String, dynamic>))
        .toList();
    if (number != 1 && number != 9 && ayahs.isNotEmpty) {
      ayahs[0] = ayahs[0].copyWithText(_stripBasmala(ayahs[0].text));
    }
    return SurahTextModel(
      number: number,
      name: (json['name'] as String).trim(),
      englishName: json['englishName'] as String? ?? '',
      isMeccan: (json['revelationType'] as String? ?? 'Meccan') == 'Meccan',
      ayahs: ayahs,
    );
  }

  // Serializes the surah for the local cache with the basmala already removed.
  Map<String, dynamic> toJson() => {
        'number': number,
        'name': name,
        'englishName': englishName,
        'revelationType': isMeccan ? 'Meccan' : 'Medinan',
        'ayahs': ayahs.map((e) => e.toJson()).toList(),
      };

  // Restores a cached surah without stripping the basmala again.
  factory SurahTextModel.fromCache(Map<String, dynamic> json) => SurahTextModel(
        number: json['number'] as int,
        name: json['name'] as String,
        englishName: json['englishName'] as String? ?? '',
        isMeccan: (json['revelationType'] as String? ?? 'Meccan') == 'Meccan',
        ayahs: (json['ayahs'] as List<dynamic>).map((e) => AyahModel.fromJson(e as Map<String, dynamic>)).toList(),
      );

  // Builds a placeholder surah for Skeletonizer loading states.
  factory SurahTextModel.dummy() => SurahTextModel(
        number: 1,
        name: 'سُورَةُ ٱلْفَاتِحَةِ',
        englishName: 'Al-Faatiha',
        isMeccan: true,
        ayahs: List.generate(7, (i) => AyahModel.dummy()),
      );

  // Returns a copy whose ayahs carry the printed mushaf text, page and juz.
  SurahTextModel withMushaf(List<MushafAyahModel> mushaf) {
    if (mushaf.length != ayahs.length) return this;
    return SurahTextModel(
      number: number,
      name: name,
      englishName: englishName,
      isMeccan: isMeccan,
      ayahs: [for (var i = 0; i < ayahs.length; i++) ayahs[i].copyWithMushaf(mushaf[i])],
    );
  }

  // Tells whether a separate basmala line should be shown above the surah.
  bool get showsBasmala => number != 1 && number != 9;

  // Returns the name without the leading word "سورة".
  String get shortName {
    final parts = name.split(' ');
    return parts.length > 1 ? parts.sublist(1).join(' ') : name;
  }

  // Returns the ayah with the given number inside the surah.
  AyahModel ayahAt(int numberInSurah) =>
      ayahs[(numberInSurah - 1).clamp(0, ayahs.length - 1).toInt()];

  // Removes the four basmala words that Tanzil prepends to the first ayah.
  static String _stripBasmala(String text) {
    final words = text.split(' ');
    if (words.length > 4 && words.first.startsWith('بِسْمِ')) {
      return words.sublist(4).join(' ').trim();
    }
    return text;
  }

  // Lists the fields used for equality.
  @override
  List<Object?> get props => [number, ayahs];
}
