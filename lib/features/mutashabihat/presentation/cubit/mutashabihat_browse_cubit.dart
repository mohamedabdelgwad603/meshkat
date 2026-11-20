import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mishkat/features/mutashabihat/data/models/mutashabih_phrase_summary_model.dart';
import 'package:mishkat/features/mutashabihat/domain/repo/mutashabihat_repo.dart';
import 'package:mishkat/features/mutashabihat/presentation/cubit/mutashabihat_browse_state.dart';
import 'package:mishkat/features/reader/data/models/mushaf_surah_model.dart';

// Lists every similar phrase and filters it by search text and surah.
class MutashabihatBrowseCubit extends Cubit<MutashabihatBrowseState> {
  final MutashabihatRepo _repo;
  List<MutashabihPhraseSummaryModel> _all = const [];
  Map<int, String> _searchText = const {};

  // Creates the cubit with the mutashabihat repository.
  MutashabihatBrowseCubit(this._repo) : super(const MutashabihatBrowseInitial());

  // Returns the cubit provided above the given context.
  static MutashabihatBrowseCubit get(BuildContext context) => BlocProvider.of(context);

  // Loads every phrase in mushaf order.
  Future<void> load() async {
    if (isClosed) return;
    emit(const MutashabihatBrowseLoading());
    final result = await _repo.getAllPhrases();
    if (isClosed) return;
    result.fold(
      (failure) => emit(MutashabihatBrowseError(failure.message)),
      (browse) {
        _all = browse.phrases;
        _searchText = {for (final p in _all) p.id: normalizeArabic(p.text)};
        emit(MutashabihatBrowseSuccess(MutashabihBrowseData(surahs: browse.surahs, visible: _all)));
      },
    );
  }

  // Shows only phrases containing the typed words, ignoring diacritics.
  void search(String query) => _apply((d) => _rebuild(d, query: query.trim()));

  // Shows only phrases appearing in the given surah, or all of them when null.
  void filterBySurah(MushafSurahModel? surah) => _apply((d) => _rebuild(d, surah: surah, clearSurah: surah == null));

  // Orders the list by mushaf position or by how often each phrase repeats.
  void setSort(MutashabihSort sort) => _apply((d) => _rebuild(d, sort: sort));

  // Rebuilds the visible list from the full list with the given changes.
  MutashabihBrowseData _rebuild(
    MutashabihBrowseData data, {
    String? query,
    MushafSurahModel? surah,
    bool clearSurah = false,
    MutashabihSort? sort,
  }) {
    final newQuery = query ?? data.query;
    final newSurah = clearSurah ? null : (surah ?? data.surah);
    final newSort = sort ?? data.sort;
    final words = normalizeArabic(newQuery).split(' ').where((w) => w.isNotEmpty).toList();
    final visible = _all
        .where((p) => newSurah == null || p.surahNumbers.contains(newSurah.number))
        .where((p) => words.every((w) => _searchText[p.id]!.contains(w)))
        .toList();
    if (newSort == MutashabihSort.mostRepeated) {
      visible.sort((a, b) => b.ayahCount != a.ayahCount ? b.ayahCount.compareTo(a.ayahCount) : a.id.compareTo(b.id));
    }
    return MutashabihBrowseData(
      surahs: data.surahs,
      visible: visible,
      query: newQuery,
      surah: newSurah,
      sort: newSort,
    );
  }

  // Emits new browse data built from the current one.
  void _apply(MutashabihBrowseData Function(MutashabihBrowseData) change) {
    final current = state;
    if (current is! MutashabihatBrowseSuccess || isClosed) return;
    emit(MutashabihatBrowseSuccess(change(current.data)));
  }
}

// Strips Arabic diacritics, Quranic marks and letter variants so searches match plain typing.
String normalizeArabic(String text) {
  var result = text.replaceAll(RegExp(r'[^ء-غف-يٱ\s]'), '');
  const variants = {'ٱ': 'ا', 'أ': 'ا', 'إ': 'ا', 'آ': 'ا', 'ى': 'ي', 'ة': 'ه'};
  variants.forEach((from, to) => result = result.replaceAll(from, to));
  return result.replaceAll(RegExp(r'\s+'), ' ').trim();
}
