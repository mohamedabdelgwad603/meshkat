import 'package:equatable/equatable.dart';
import 'package:mishkat/features/mutashabihat/data/models/mutashabih_phrase_summary_model.dart';
import 'package:mishkat/features/reader/data/models/mushaf_surah_model.dart';

// How the browse list is ordered.
enum MutashabihSort { mushaf, mostRepeated }

// The phrase list with the current search, surah filter and order.
class MutashabihBrowseData extends Equatable {
  final List<MushafSurahModel> surahs;
  final List<MutashabihPhraseSummaryModel> visible;
  final String query;
  final MushafSurahModel? surah;
  final MutashabihSort sort;

  // Creates the browse data.
  const MutashabihBrowseData({
    required this.surahs,
    required this.visible,
    this.query = '',
    this.surah,
    this.sort = MutashabihSort.mushaf,
  });

  // Lists the fields used for equality.
  @override
  List<Object?> get props => [visible.length, visible.isEmpty ? null : visible.first.id, query, surah?.number, sort];
}

// Base state of the mutashabihat browser.
abstract class MutashabihatBrowseState extends Equatable {
  // Creates the base state.
  const MutashabihatBrowseState();

  // Lists the fields used for equality.
  @override
  List<Object?> get props => [];
}

// The browser has not loaded yet.
class MutashabihatBrowseInitial extends MutashabihatBrowseState {
  // Creates the initial state.
  const MutashabihatBrowseInitial();
}

// The phrases are loading.
class MutashabihatBrowseLoading extends MutashabihatBrowseState {
  // Creates the loading state.
  const MutashabihatBrowseLoading();
}

// The phrases are available.
class MutashabihatBrowseSuccess extends MutashabihatBrowseState {
  final MutashabihBrowseData data;

  // Creates the success state.
  const MutashabihatBrowseSuccess(this.data);

  // Lists the fields used for equality.
  @override
  List<Object?> get props => [data];
}

// The browser failed to load; message is a translation key.
class MutashabihatBrowseError extends MutashabihatBrowseState {
  final String message;

  // Creates the error state.
  const MutashabihatBrowseError(this.message);

  // Lists the fields used for equality.
  @override
  List<Object?> get props => [message];
}
