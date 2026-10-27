import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mishkat/features/bookmarks/data/models/bookmark_model.dart';
import 'package:mishkat/features/bookmarks/data/models/last_read_model.dart';
import 'package:mishkat/features/bookmarks/presentation/cubit/bookmarks_cubit.dart';
import 'package:mishkat/features/reader/data/models/mushaf_model.dart';
import 'package:mishkat/features/reader/domain/repo/reader_repo.dart';
import 'package:mishkat/features/reader/presentation/cubit/reader_state.dart';

// Loads the mushaf, pages through it like the printed copy and tracks the selected ayah.
class ReaderCubit extends Cubit<ReaderState> {
  final ReaderRepo _repo;
  final BookmarksCubit _bookmarksCubit;

  // Creates the cubit with the reader repository and the shared bookmarks cubit.
  ReaderCubit(this._repo, this._bookmarksCubit) : super(const ReaderInitial());

  // Returns the cubit provided above the given context.
  static ReaderCubit get(BuildContext context) => BlocProvider.of(context);

  // Loads the mushaf and opens it on the page where the given ayah starts.
  Future<void> load(int surahNumber, {int initialAyah = 1}) async {
    if (isClosed) return;
    emit(const ReaderLoading());
    final result = await _repo.getMushaf();
    if (isClosed) return;
    result.fold(
      (failure) => emit(ReaderError(failure.message)),
      (mushaf) {
        final index = mushaf.pageIndexOf(surahNumber, initialAyah);
        emit(ReaderSuccess(mushaf: mushaf, initialPageIndex: index, currentPageIndex: index));
        _saveLastRead(mushaf, surahNumber, initialAyah, index);
      },
    );
  }

  // Records the newly shown page and saves its first ayah as the last-read position.
  void onPageChanged(int index) {
    final current = state;
    if (current is! ReaderSuccess) return;
    if (isClosed) return;
    emit(current.copyWith(currentPageIndex: index, clearSelection: true));
    final first = current.mushaf.firstAyahStartingOn(index);
    _saveLastRead(current.mushaf, first.surah, first.ayah, index);
  }

  // Selects an ayah, or clears the selection when it is tapped again.
  void selectAyah(int surahNumber, int ayahNumber) {
    final current = state;
    if (current is! ReaderSuccess) return;
    if (isClosed) return;
    if (current.selectedSurah == surahNumber && current.selectedAyah == ayahNumber) {
      emit(current.copyWith(clearSelection: true));
      return;
    }
    emit(current.copyWith(selectedSurah: surahNumber, selectedAyah: ayahNumber));
    _saveLastRead(current.mushaf, surahNumber, ayahNumber, current.currentPageIndex);
  }

  // Clears the selected ayah.
  void clearSelection() {
    final current = state;
    if (current is! ReaderSuccess) return;
    if (isClosed) return;
    emit(current.copyWith(clearSelection: true));
  }

  // Adds or removes the given ayah from the saved list and returns true when it is now saved.
  Future<bool> toggleBookmark(int surahNumber, int ayahNumber) async {
    final current = state;
    if (current is! ReaderSuccess) return false;
    final surah = current.mushaf.surah(surahNumber);
    return _bookmarksCubit.toggle(BookmarkModel(
      surahNumber: surahNumber,
      surahName: surah.shortName,
      surahEnglishName: surah.englishName,
      ayahNumber: ayahNumber,
      text: current.mushaf.ayah(surahNumber, ayahNumber).text,
      createdAt: DateTime.now(),
    ));
  }

  // Saves the given ayah on the given page as the last-read position.
  void _saveLastRead(MushafModel mushaf, int surahNumber, int ayahNumber, int pageIndex) {
    final surah = mushaf.surah(surahNumber);
    final page = mushaf.pages[pageIndex];
    _bookmarksCubit.saveLastRead(LastReadModel(
      surahNumber: surahNumber,
      surahName: surah.shortName,
      surahEnglishName: surah.englishName,
      ayahNumber: ayahNumber,
      numberOfAyahs: surah.ayahCount,
      juz: page.juz,
      page: page.number,
    ));
  }
}
