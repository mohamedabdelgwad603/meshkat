// Arguments for opening the mushaf reader on a surah and optional ayah.
class ReaderArgs {
  final int surahNumber;
  final int initialAyah;

  // Creates reader arguments.
  const ReaderArgs({required this.surahNumber, this.initialAyah = 1});
}

// Arguments for opening the tafsir of an ayah.
class TafsirArgs {
  final int surahNumber;
  final int ayahNumber;

  // Creates tafsir arguments.
  const TafsirArgs({required this.surahNumber, required this.ayahNumber});
}

// Arguments for opening the player on a surah starting from an ayah.
class PlayerArgs {
  final int surahNumber;
  final int startAyah;

  // Creates player arguments.
  const PlayerArgs({required this.surahNumber, this.startAyah = 1});
}
