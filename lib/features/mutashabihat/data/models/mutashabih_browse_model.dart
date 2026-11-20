import 'package:mishkat/features/mutashabihat/data/models/mutashabih_phrase_summary_model.dart';
import 'package:mishkat/features/reader/data/models/mushaf_surah_model.dart';

// Every similar phrase of the Quran with the surah list used to filter them.
class MutashabihBrowseModel {
  final List<MutashabihPhraseSummaryModel> phrases;
  final List<MushafSurahModel> surahs;

  // Creates the browse data.
  const MutashabihBrowseModel({required this.phrases, required this.surahs});
}
