import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mishkat/core/utills/functions/arabic_normalizer.dart';
import 'package:mishkat/features/surahs/data/models/surah_model.dart';
import 'package:mishkat/features/surahs/domain/repo/surahs_repo.dart';
import 'package:mishkat/features/surahs/presentation/cubit/surahs_state.dart';

// Loads the surah index and filters it by the search query.
class SurahsCubit extends Cubit<SurahsState> {
  final SurahsRepo _repo;

  // Creates the cubit with the surahs repository.
  SurahsCubit(this._repo) : super(const SurahsInitial());

  // Returns the cubit provided above the given context.
  static SurahsCubit get(BuildContext context) => BlocProvider.of(context);

  // Loads all surahs and the juz table.
  Future<void> loadSurahs() async {
    if (isClosed) return;
    emit(const SurahsLoading());
    final result = await _repo.getSurahs();
    if (isClosed) return;
    result.fold(
      (failure) => emit(SurahsError(failure.message)),
      (surahs) => emit(SurahsSuccess(surahs: surahs, filtered: surahs, juzList: _repo.getJuzList())),
    );
  }

  // Filters the loaded surahs by name or number.
  void search(String query) {
    final current = state;
    if (current is! SurahsSuccess) return;
    if (isClosed) return;
    emit(SurahsSuccess(
      surahs: current.surahs,
      filtered: _filter(current.surahs, query),
      juzList: current.juzList,
      query: query,
    ));
  }

  // Returns the surahs whose number or normalized names contain the query.
  List<SurahModel> _filter(List<SurahModel> surahs, String query) {
    final q = normalizeArabic(toWesternDigits(query));
    if (q.isEmpty) return surahs;
    return surahs.where((s) {
      return s.number.toString() == q ||
          normalizeArabic(s.name).contains(q) ||
          normalizeArabic(s.englishName).contains(q) ||
          normalizeArabic(s.englishNameTranslation).contains(q);
    }).toList();
  }
}
