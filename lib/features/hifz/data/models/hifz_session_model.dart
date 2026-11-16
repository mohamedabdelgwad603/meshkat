import 'package:mishkat/features/hifz/data/models/hifz_ayah_model.dart';

// The ayahs of a memorization range with the surah and reciter names shown during the session.
class HifzSessionModel {
  final String surahName;
  final String surahEnglishName;
  final String reciterName;
  final List<HifzAyahModel> ayahs;

  // Creates the session content.
  const HifzSessionModel({
    required this.surahName,
    required this.surahEnglishName,
    required this.reciterName,
    required this.ayahs,
  });

  // Reads the session content from the values collected by the repository.
  factory HifzSessionModel.fromJson(Map<String, dynamic> json) => HifzSessionModel(
        surahName: json['surahName'] as String,
        surahEnglishName: json['surahEnglishName'] as String? ?? '',
        reciterName: json['reciterName'] as String? ?? '',
        ayahs: (json['ayahs'] as List<dynamic>).map((e) => HifzAyahModel.fromJson(e as Map<String, dynamic>)).toList(),
      );

  // Builds placeholder content for Skeletonizer loading states.
  factory HifzSessionModel.dummy() => HifzSessionModel(
        surahName: 'ٱلْفَاتِحَةِ',
        surahEnglishName: 'Al-Faatiha',
        reciterName: 'محمود خليل الحصري',
        ayahs: List.generate(3, (_) => HifzAyahModel.dummy()),
      );

  // Returns the surah name suited to the current language.
  String displaySurah(bool isArabic) => isArabic || surahEnglishName.isEmpty ? surahName : surahEnglishName;
}
