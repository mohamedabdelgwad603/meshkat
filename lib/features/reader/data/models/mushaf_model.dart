import 'package:mishkat/features/reader/data/models/ayah_model.dart';
import 'package:mishkat/features/reader/data/models/mushaf_ayah_model.dart';
import 'package:mishkat/features/reader/data/models/mushaf_page_model.dart';
import 'package:mishkat/features/reader/data/models/mushaf_surah_model.dart';

// The whole Madani mushaf: 604 laid-out pages, the 114 surahs and the text of every ayah.
class MushafModel {
  final List<MushafSurahModel> surahs;
  final List<MushafPageModel> pages;
  final Map<int, List<MushafAyahModel>> _ayahs;
  final Map<int, int> _startPageIndex;
  final List<int> _ayahsBefore;

  // Creates the mushaf and indexes where each ayah starts.
  MushafModel({required this.surahs, required this.pages, required Map<int, List<MushafAyahModel>> ayahs})
      : _ayahs = ayahs,
        _startPageIndex = _indexStarts(pages),
        _ayahsBefore = _countBefore(surahs);

  // Parses the page layout JSON together with the per-surah ayah texts.
  factory MushafModel.fromJson(Map<String, dynamic> json, Map<int, List<MushafAyahModel>> ayahs) {
    final surahs = json['surahs'] as List<dynamic>;
    final pages = json['pages'] as List<dynamic>;
    return MushafModel(
      surahs: [for (var i = 0; i < surahs.length; i++) MushafSurahModel.fromJson(surahs[i] as Map<String, dynamic>, i + 1)],
      pages: [for (var i = 0; i < pages.length; i++) MushafPageModel.fromJson(pages[i] as Map<String, dynamic>, i + 1)],
      ayahs: ayahs,
    );
  }

  // Builds a placeholder one-page mushaf for Skeletonizer loading states.
  factory MushafModel.dummy() => MushafModel(
        surahs: [MushafSurahModel.dummy()],
        pages: [MushafPageModel.dummy()],
        ayahs: {1: List.generate(7, (_) => MushafAyahModel.dummy())},
      );

  // Returns the surah with the given number.
  MushafSurahModel surah(int number) => surahs[(number - 1).clamp(0, surahs.length - 1).toInt()];

  // Returns the index of the page where the given ayah starts.
  int pageIndexOf(int surahNumber, int ayahNumber) => _startPageIndex[_key(surahNumber, ayahNumber)] ?? 0;

  // Returns the first ayah that starts on the given page, or the page's first word's ayah.
  ({int surah, int ayah}) firstAyahStartingOn(int pageIndex) {
    for (final word in pages[pageIndex].lines.expand((l) => l.words)) {
      if (pageIndexOf(word.surah, word.ayah) == pageIndex) return (surah: word.surah, ayah: word.ayah);
    }
    final first = pages[pageIndex].firstWord;
    return (surah: first.surah, ayah: first.ayah);
  }

  // Returns the given ayah with its mushaf text, page and juz.
  AyahModel ayah(int surahNumber, int ayahNumber) {
    final list = _ayahs[surahNumber] ?? const [];
    final mushaf = list.isEmpty ? MushafAyahModel.dummy() : list[(ayahNumber - 1).clamp(0, list.length - 1).toInt()];
    return AyahModel(
      number: _ayahsBefore[(surahNumber - 1).clamp(0, _ayahsBefore.length - 1).toInt()] + ayahNumber,
      numberInSurah: ayahNumber,
      text: mushaf.text,
      juz: mushaf.juz,
      page: mushaf.page,
    );
  }

  // Builds a unique key for a surah and ayah pair.
  static int _key(int surah, int ayah) => surah * 1000 + ayah;

  // Maps every ayah to the index of the page holding its first word.
  static Map<int, int> _indexStarts(List<MushafPageModel> pages) {
    final starts = <int, int>{};
    for (var i = 0; i < pages.length; i++) {
      for (final word in pages[i].lines.expand((l) => l.words)) {
        starts.putIfAbsent(_key(word.surah, word.ayah), () => i);
      }
    }
    return starts;
  }

  // Counts the ayahs that come before each surah in the whole Quran.
  static List<int> _countBefore(List<MushafSurahModel> surahs) {
    final before = <int>[];
    var total = 0;
    for (final s in surahs) {
      before.add(total);
      total += s.ayahCount;
    }
    return before;
  }
}
