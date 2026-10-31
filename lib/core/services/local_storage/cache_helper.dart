import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

// Thin wrapper over SharedPreferences used by local data sources.
class CacheHelper {
  final SharedPreferences _prefs;

  // Creates the helper around an initialized SharedPreferences instance.
  CacheHelper(this._prefs);

  // Stores a JSON-encodable value under the given key.
  Future<void> saveJson(String key, Object value) => _prefs.setString(key, jsonEncode(value));

  // Reads and decodes a JSON value stored under the given key.
  dynamic readJson(String key) {
    final raw = _prefs.getString(key);
    return raw == null ? null : jsonDecode(raw);
  }

  // Stores a string value.
  Future<void> saveString(String key, String value) => _prefs.setString(key, value);

  // Reads a string value.
  String? readString(String key) => _prefs.getString(key);

  // Stores a double value.
  Future<void> saveDouble(String key, double value) => _prefs.setDouble(key, value);

  // Reads a double value.
  double? readDouble(String key) => _prefs.getDouble(key);

  // Removes the value stored under the given key.
  Future<void> remove(String key) => _prefs.remove(key);
}

// Holds the keys used in local storage.
class CacheKeys {
  CacheKeys._();

  static const String surahList = 'surah_list';
  static const String lastRead = 'last_read';
  static const String bookmarks = 'bookmarks';
  static const String reciter = 'reciter';
  static const String quranFontSize = 'quran_font_size';
  static const String tafsirEdition = 'tafsir_edition';
  static const String tafsirEditions = 'tafsir_editions';
  static const String reciters = 'reciters_v3';

  // Builds the cache key of a surah's text.
  static String surahText(int number) => 'surah_text_$number';

  // Builds the cache key of a surah's audio list for a reciter.
  static String surahAudio(int number, String reciter) => 'surah_audio_${reciter}_$number';

  // Builds the cache key of the daily ayah for a given day.
  static String dailyAyah(int day) => 'daily_ayah_$day';
}
