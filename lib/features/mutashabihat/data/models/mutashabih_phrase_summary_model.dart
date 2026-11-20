// A phrase in the browse list: its text, counts and where it first appears.
class MutashabihPhraseSummaryModel {
  final int id;
  final String text;
  final int ayahCount;
  final int surahCount;
  final Set<int> surahNumbers;
  final int firstSurah;
  final int firstAyah;
  final String firstSurahName;
  final String firstSurahEnglishName;

  // Creates the summary.
  const MutashabihPhraseSummaryModel({
    required this.id,
    required this.text,
    required this.ayahCount,
    required this.surahCount,
    required this.surahNumbers,
    required this.firstSurah,
    required this.firstAyah,
    required this.firstSurahName,
    required this.firstSurahEnglishName,
  });

  // Returns the first surah name suited to the current language.
  String displayFirstSurah(bool isArabic) =>
      isArabic || firstSurahEnglishName.isEmpty ? firstSurahName : firstSurahEnglishName;

  // Builds a placeholder for Skeletonizer loading states.
  factory MutashabihPhraseSummaryModel.dummy() => const MutashabihPhraseSummaryModel(
        id: 0,
        text: 'مِّن دُونِ ٱللَّهِ',
        ayahCount: 70,
        surahCount: 32,
        surahNumbers: {2},
        firstSurah: 2,
        firstAyah: 23,
        firstSurahName: 'البقرة',
        firstSurahEnglishName: 'Al-Baqara',
      );
}
