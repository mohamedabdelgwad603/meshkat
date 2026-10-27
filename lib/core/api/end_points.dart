// Holds the base URLs and paths of the Al Quran Cloud API (free, key-less, Tanzil-sourced text).
class EndPoints {
  EndPoints._();

  static const String baseUrl = 'https://api.alquran.cloud/v1';

  // Text edition with full Uthmani script from Tanzil.
  static const String quranEdition = 'quran-uthmani';

  // Default tafsir and reciter editions.
  static const String defaultTafsir = 'ar.muyassar';
  static const String defaultReciter = 'ar.alafasy';

  // Lists the 114 surahs with their metadata.
  static const String surahs = '/surah';

  // Lists editions filtered by format, type and language.
  static const String editions = '/edition';

  // Returns a surah in the given edition.
  static String surah(int number, String edition) => '/surah/$number/$edition';

  // Returns one ayah (global number or "surah:ayah") in the given edition.
  static String ayah(String reference, String edition) => '/ayah/$reference/$edition';
}
