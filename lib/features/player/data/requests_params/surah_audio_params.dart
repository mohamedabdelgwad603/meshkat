// Identifies which surah's recitation to fetch and by which reciter.
class SurahAudioParams {
  final int surahNumber;
  final String reciter;

  // Creates the params.
  const SurahAudioParams({required this.surahNumber, required this.reciter});

  // Serializes the params; the API takes them as path segments.
  Map<String, dynamic> toJson() => {'surah': surahNumber, 'reciter': reciter};
}
