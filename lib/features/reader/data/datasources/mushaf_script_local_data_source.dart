import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:mishkat/core/errors/exceptions.dart';
import 'package:mishkat/core/utills/assets_manager.dart';
import 'package:mishkat/core/utills/text_manager.dart';
import 'package:mishkat/features/reader/data/models/mushaf_ayah_model.dart';
import 'package:mishkat/features/reader/data/models/mushaf_model.dart';

// Reads the bundled King Fahd Complex Hafs text and the Madani page layout written for the mushaf font.
abstract class MushafScriptLocalDataSource {
  // Returns every ayah of a surah as printed in the mushaf.
  Future<List<MushafAyahModel>> getSurahScript(int surahNumber);

  // Returns one ayah as printed in the mushaf.
  Future<MushafAyahModel> getAyahScript(int surahNumber, int ayahNumber);

  // Returns the whole mushaf laid out page by page.
  Future<MushafModel> getMushaf();
}

// Asset implementation of MushafScriptLocalDataSource that loads each file once and keeps it in memory.
class MushafScriptLocalDataSourceImp implements MushafScriptLocalDataSource {
  Future<Map<int, List<MushafAyahModel>>>? _ayahs;
  Future<MushafModel>? _mushaf;

  // Returns every ayah of a surah as printed in the mushaf.
  @override
  Future<List<MushafAyahModel>> getSurahScript(int surahNumber) async {
    final ayahs = (await (_ayahs ??= _loadAyahs()))[surahNumber];
    if (ayahs == null) throw const CacheException(TextManager.errorCache);
    return ayahs;
  }

  // Returns one ayah as printed in the mushaf.
  @override
  Future<MushafAyahModel> getAyahScript(int surahNumber, int ayahNumber) async {
    final ayahs = await getSurahScript(surahNumber);
    if (ayahNumber < 1 || ayahNumber > ayahs.length) throw const CacheException(TextManager.errorCache);
    return ayahs[ayahNumber - 1];
  }

  // Returns the whole mushaf laid out page by page.
  @override
  Future<MushafModel> getMushaf() => _mushaf ??= _loadMushaf();

  // Reads the ayah texts and parses them off the UI thread.
  static Future<Map<int, List<MushafAyahModel>>> _loadAyahs() async =>
      compute(_parseAyahs, await rootBundle.loadString(AssetsManager.mushafText));

  // Reads the page layout and the ayah texts and builds the mushaf off the UI thread.
  static Future<MushafModel> _loadMushaf() async {
    final pages = await rootBundle.loadString(AssetsManager.mushafPages);
    final ayahs = await rootBundle.loadString(AssetsManager.mushafText);
    return compute(_parseMushaf, (pages, ayahs));
  }

  // Parses the per-surah ayah texts.
  static Map<int, List<MushafAyahModel>> _parseAyahs(String raw) => {
        for (final entry in (jsonDecode(raw) as Map<String, dynamic>).entries)
          int.parse(entry.key): (entry.value as List<dynamic>)
              .map((e) => MushafAyahModel.fromJson(e as Map<String, dynamic>))
              .toList(),
      };

  // Parses the page layout and joins it with the ayah texts.
  static MushafModel _parseMushaf((String, String) raw) =>
      MushafModel.fromJson(jsonDecode(raw.$1) as Map<String, dynamic>, _parseAyahs(raw.$2));
}
