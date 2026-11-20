import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:mishkat/core/utills/assets_manager.dart';
import 'package:mishkat/features/mutashabihat/data/models/mutashabih_phrase_model.dart';

// Reads the bundled mutashabihat phrases (from QUL by Tarteel), prepared by tool/mutashabihat.
abstract class MutashabihatLocalDataSource {
  // Returns every phrase keyed by its id.
  Future<Map<int, MutashabihPhraseModel>> getPhrases();

  // Returns, for every ayah key that has similar phrases, the ids of those phrases.
  Future<Map<String, List<int>>> getAyahIndex();
}

// Asset implementation of MutashabihatLocalDataSource that parses the file once off the UI thread.
class MutashabihatLocalDataSourceImp implements MutashabihatLocalDataSource {
  Future<Map<int, MutashabihPhraseModel>>? _phrases;
  Future<Map<String, List<int>>>? _index;

  // Returns every phrase keyed by its id.
  @override
  Future<Map<int, MutashabihPhraseModel>> getPhrases() => _phrases ??= _load();

  // Returns, for every ayah key that has similar phrases, the ids of those phrases.
  @override
  Future<Map<String, List<int>>> getAyahIndex() => _index ??= getPhrases().then(_buildIndex);

  // Reads the asset and parses it in a background isolate.
  static Future<Map<int, MutashabihPhraseModel>> _load() async =>
      compute(_parse, await rootBundle.loadString(AssetsManager.mutashabihat));

  // Parses the phrase list into a map keyed by id.
  static Map<int, MutashabihPhraseModel> _parse(String raw) => {
        for (final item in (jsonDecode(raw) as Map<String, dynamic>)['phrases'] as List<dynamic>)
          (item as Map<String, dynamic>)['id'] as int: MutashabihPhraseModel.fromJson(item),
      };

  // Groups phrase ids by the ayahs they appear in.
  static Map<String, List<int>> _buildIndex(Map<int, MutashabihPhraseModel> phrases) {
    final index = <String, List<int>>{};
    for (final phrase in phrases.values) {
      for (final key in phrase.ayahs.keys) {
        (index[key] ??= []).add(phrase.id);
      }
    }
    return index;
  }
}
