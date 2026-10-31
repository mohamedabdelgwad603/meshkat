// Holds the base URLs and paths of the Al Quran Cloud API (free, key-less, Tanzil-sourced text).
class EndPoints {
  EndPoints._();

  static const String baseUrl = 'https://api.alquran.cloud/v1';

  // Text edition with full Uthmani script from Tanzil.
  static const String quranEdition = 'quran-uthmani';

  // Default tafsir and reciter editions.
  static const String defaultTafsir = 'ar.muyassar';
  static const String defaultReciter = 'ar.alafasy';

  // Reciters listed outside the verse-by-verse editions; Al-Banna's ayah audio comes from EveryAyah.
  static const String minshawiReciter = 'ar.minshawi';
  static const String bannaReciter = 'ar.mahmoudalialbanna';
  static const String bannaEveryAyahFolder = 'mahmoud_ali_al_banna_32kbps';

  // Reciters shown at the top of the list, in this order.
  static const List<String> pinnedReciters = [bannaReciter, minshawiReciter, 'ar.husary'];

  // Lists the 114 surahs with their metadata.
  static const String surahs = '/surah';

  // Lists editions filtered by format, type and language.
  static const String editions = '/edition';

  // Returns a surah in the given edition.
  static String surah(int number, String edition) => '/surah/$number/$edition';

  // Returns one ayah (global number or "surah:ayah") in the given edition.
  static String ayah(String reference, String edition) => '/ayah/$reference/$edition';

  // Returns the EveryAyah audio URL of one ayah, named by zero-padded surah and ayah numbers.
  static String everyAyahAudio(String folder, int surah, int ayah) =>
      'https://everyayah.com/data/$folder/${surah.toString().padLeft(3, '0')}${ayah.toString().padLeft(3, '0')}.mp3';
}
