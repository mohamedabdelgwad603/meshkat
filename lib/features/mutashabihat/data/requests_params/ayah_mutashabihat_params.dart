// The ayah whose similar phrases are requested.
class AyahMutashabihatParams {
  final int surahNumber;
  final int ayahNumber;

  // Creates the params.
  const AyahMutashabihatParams({required this.surahNumber, required this.ayahNumber});

  // Returns the "surah:ayah" key used by the mutashabihat data.
  String get key => '$surahNumber:$ayahNumber';

  // Serializes the params.
  Map<String, dynamic> toJson() => {'surahNumber': surahNumber, 'ayahNumber': ayahNumber};
}
