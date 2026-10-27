// Identifies the ayah and tafsir edition to fetch.
class TafsirParams {
  final int surahNumber;
  final int ayahNumber;
  final String edition;

  // Creates the tafsir params.
  const TafsirParams({required this.surahNumber, required this.ayahNumber, required this.edition});

  // Returns the "surah:ayah" reference the API expects.
  String get reference => '$surahNumber:$ayahNumber';

  // Serializes the params.
  Map<String, dynamic> toJson() => {'reference': reference, 'edition': edition};
}
