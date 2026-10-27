import 'package:equatable/equatable.dart';
import 'package:mishkat/features/reader/data/models/ayah_model.dart';
import 'package:mishkat/features/reader/data/models/mushaf_model.dart';
import 'package:mishkat/features/reader/data/models/mushaf_page_model.dart';
import 'package:mishkat/features/reader/data/models/mushaf_surah_model.dart';

// Base state of the mushaf reader.
abstract class ReaderState extends Equatable {
  // Creates the base state.
  const ReaderState();

  // Lists the fields used for equality.
  @override
  List<Object?> get props => [];
}

// Reader has not started loading.
class ReaderInitial extends ReaderState {
  // Creates the initial state.
  const ReaderInitial();
}

// Mushaf is loading.
class ReaderLoading extends ReaderState {
  // Creates the loading state.
  const ReaderLoading();
}

// Mushaf loaded and opened on a page.
class ReaderSuccess extends ReaderState {
  final MushafModel mushaf;
  final int initialPageIndex;
  final int currentPageIndex;
  final int? selectedSurah;
  final int? selectedAyah;

  // Creates the success state.
  const ReaderSuccess({
    required this.mushaf,
    required this.initialPageIndex,
    required this.currentPageIndex,
    this.selectedSurah,
    this.selectedAyah,
  });

  // Returns the page currently shown.
  MushafPageModel get currentPage => mushaf.pages[currentPageIndex];

  // Returns the surah the current page belongs to.
  MushafSurahModel get currentSurah => mushaf.surah(currentPage.firstWord.surah);

  // Tells whether an ayah is selected.
  bool get hasSelection => selectedSurah != null && selectedAyah != null;

  // Returns the selected ayah, or null when nothing is selected.
  AyahModel? get selectedAyahModel => hasSelection ? mushaf.ayah(selectedSurah!, selectedAyah!) : null;

  // Returns a copy with the given fields replaced; pass clearSelection to deselect.
  ReaderSuccess copyWith({int? currentPageIndex, int? selectedSurah, int? selectedAyah, bool clearSelection = false}) =>
      ReaderSuccess(
        mushaf: mushaf,
        initialPageIndex: initialPageIndex,
        currentPageIndex: currentPageIndex ?? this.currentPageIndex,
        selectedSurah: clearSelection ? null : (selectedSurah ?? this.selectedSurah),
        selectedAyah: clearSelection ? null : (selectedAyah ?? this.selectedAyah),
      );

  // Lists the fields used for equality.
  @override
  List<Object?> get props => [mushaf, currentPageIndex, selectedSurah, selectedAyah];
}

// Mushaf failed to load; message is a translation key.
class ReaderError extends ReaderState {
  final String message;

  // Creates the error state.
  const ReaderError(this.message);

  // Lists the fields used for equality.
  @override
  List<Object?> get props => [message];
}
