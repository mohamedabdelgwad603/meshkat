import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mishkat/features/bookmarks/data/models/bookmark_model.dart';
import 'package:mishkat/features/bookmarks/data/models/last_read_model.dart';
import 'package:mishkat/features/bookmarks/presentation/cubit/bookmarks_cubit.dart';
import 'package:mishkat/features/reader/data/models/ayah_model.dart';
import 'package:mishkat/features/reader/data/models/surah_text_model.dart';
import 'package:mishkat/features/reader/data/requests_params/surah_text_params.dart';
import 'package:mishkat/features/reader/domain/repo/reader_repo.dart';
import 'package:mishkat/features/reader/presentation/cubit/reader_state.dart';

// Loads a surah, pages through it like a mushaf and tracks the selected ayah.
class ReaderCubit extends Cubit<ReaderState> {
  final ReaderRepo _repo;
  final BookmarksCubit _bookmarksCubit;

  // Creates the cubit with the reader repository and the shared bookmarks cubit.
  ReaderCubit(this._repo, this._bookmarksCubit) : super(const ReaderInitial());

  // Returns the cubit provided above the given context.
  static ReaderCubit get(BuildContext context) => BlocProvider.of(context);

  // Loads the surah and opens it on the page holding the initial ayah.
  Future<void> load(int surahNumber, {int initialAyah = 1}) async {
    if (isClosed) return;
    emit(const ReaderLoading());
    final result = await _repo.getSurahText(SurahTextParams(surahNumber: surahNumber));
    if (isClosed) return;
    result.fold(
      (failure) => emit(ReaderError(failure.message)),
      (surah) {
        final pages = _groupByPage(surah.ayahs);
        final initialIndex = pages.indexWhere((p) => p.any((a) => a.numberInSurah == initialAyah));
        final safeIndex = initialIndex < 0 ? 0 : initialIndex;
        emit(ReaderSuccess(surah: surah, pages: pages, initialPageIndex: safeIndex, currentPageIndex: safeIndex));
        _saveLastRead(surah, surah.ayahAt(initialAyah));
      },
    );
  }

  // Records the newly shown page and saves it as the last-read position.
  void onPageChanged(int index) {
    final current = state;
    if (current is! ReaderSuccess) return;
    if (isClosed) return;
    emit(current.copyWith(currentPageIndex: index, clearSelection: true));
    _saveLastRead(current.surah, current.pages[index].first);
  }

  // Selects an ayah, or clears the selection when it is tapped again.
  void selectAyah(int numberInSurah) {
    final current = state;
    if (current is! ReaderSuccess) return;
    if (isClosed) return;
    if (current.selectedAyah == numberInSurah) {
      emit(current.copyWith(clearSelection: true));
      return;
    }
    emit(current.copyWith(selectedAyah: numberInSurah));
    _saveLastRead(current.surah, current.surah.ayahAt(numberInSurah));
  }

  // Clears the selected ayah.
  void clearSelection() {
    final current = state;
    if (current is! ReaderSuccess) return;
    if (isClosed) return;
    emit(current.copyWith(clearSelection: true));
  }

  // Adds or removes the selected ayah from the saved list and returns true when it is now saved.
  Future<bool> toggleBookmark(AyahModel ayah) async {
    final current = state;
    if (current is! ReaderSuccess) return false;
    return _bookmarksCubit.toggle(BookmarkModel(
      surahNumber: current.surah.number,
      surahName: current.surah.shortName,
      surahEnglishName: current.surah.englishName,
      ayahNumber: ayah.numberInSurah,
      text: ayah.text,
      createdAt: DateTime.now(),
    ));
  }

  // Saves the given ayah as the last-read position.
  void _saveLastRead(SurahTextModel surah, AyahModel ayah) {
    _bookmarksCubit.saveLastRead(LastReadModel(
      surahNumber: surah.number,
      surahName: surah.shortName,
      surahEnglishName: surah.englishName,
      ayahNumber: ayah.numberInSurah,
      numberOfAyahs: surah.ayahs.length,
      juz: ayah.juz,
      page: ayah.page,
    ));
  }

  // Splits the ayahs into consecutive groups that share a mushaf page.
  List<List<AyahModel>> _groupByPage(List<AyahModel> ayahs) {
    final pages = <List<AyahModel>>[];
    for (final ayah in ayahs) {
      if (pages.isEmpty || pages.last.first.page != ayah.page) {
        pages.add([ayah]);
      } else {
        pages.last.add(ayah);
      }
    }
    return pages;
  }
}
