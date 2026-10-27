import 'package:equatable/equatable.dart';
import 'package:mishkat/features/reader/data/models/ayah_model.dart';
import 'package:mishkat/features/reader/data/models/surah_text_model.dart';

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

// Surah text is loading.
class ReaderLoading extends ReaderState {
  // Creates the loading state.
  const ReaderLoading();
}

// Surah loaded and split into mushaf pages.
class ReaderSuccess extends ReaderState {
  final SurahTextModel surah;
  final List<List<AyahModel>> pages;
  final int initialPageIndex;
  final int currentPageIndex;
  final int? selectedAyah;

  // Creates the success state.
  const ReaderSuccess({
    required this.surah,
    required this.pages,
    required this.initialPageIndex,
    required this.currentPageIndex,
    this.selectedAyah,
  });

  // Returns the ayahs on the page currently shown.
  List<AyahModel> get currentPage => pages[currentPageIndex];

  // Returns a copy with the given fields replaced; pass clearSelection to deselect.
  ReaderSuccess copyWith({int? currentPageIndex, int? selectedAyah, bool clearSelection = false}) => ReaderSuccess(
        surah: surah,
        pages: pages,
        initialPageIndex: initialPageIndex,
        currentPageIndex: currentPageIndex ?? this.currentPageIndex,
        selectedAyah: clearSelection ? null : (selectedAyah ?? this.selectedAyah),
      );

  // Lists the fields used for equality.
  @override
  List<Object?> get props => [surah, currentPageIndex, selectedAyah];
}

// Surah failed to load; message is a translation key.
class ReaderError extends ReaderState {
  final String message;

  // Creates the error state.
  const ReaderError(this.message);

  // Lists the fields used for equality.
  @override
  List<Object?> get props => [message];
}
