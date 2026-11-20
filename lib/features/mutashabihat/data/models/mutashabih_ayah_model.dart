// One ayah shown in the mutashabihat page with the word ranges to highlight.
class MutashabihAyahModel {
  final int surahNumber;
  final int ayahNumber;
  final String surahName;
  final String surahEnglishName;
  final List<String> words;
  final List<(int, int)> highlights;

  // Creates the ayah.
  const MutashabihAyahModel({
    required this.surahNumber,
    required this.ayahNumber,
    required this.surahName,
    required this.surahEnglishName,
    required this.words,
    required this.highlights,
  });

  // Tells whether the word at the given 1-based position is inside a highlighted range.
  bool isHighlighted(int position) => highlights.any((r) => position >= r.$1 && position <= r.$2);

  // Returns the surah name suited to the current language.
  String displaySurah(bool isArabic) => isArabic || surahEnglishName.isEmpty ? surahName : surahEnglishName;

  // Builds a placeholder ayah for Skeletonizer loading states.
  factory MutashabihAyahModel.dummy() => const MutashabihAyahModel(
        surahNumber: 2,
        ayahNumber: 107,
        surahName: 'البقرة',
        surahEnglishName: 'Al-Baqara',
        words: ['وَمَا', 'لَكُم', 'مِّن', 'دُونِ', 'ٱللَّهِ', 'مِن', 'وَلِيّٖ', 'وَلَا', 'نَصِيرٍ'],
        highlights: [(3, 5)],
      );
}
