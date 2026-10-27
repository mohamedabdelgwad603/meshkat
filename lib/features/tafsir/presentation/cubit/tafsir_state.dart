import 'package:equatable/equatable.dart';
import 'package:mishkat/features/reader/data/models/ayah_model.dart';
import 'package:mishkat/features/reader/data/models/surah_text_model.dart';
import 'package:mishkat/features/tafsir/data/models/tafsir_edition_model.dart';
import 'package:mishkat/features/tafsir/data/models/tafsir_model.dart';

// Base state of the tafsir screen.
abstract class TafsirState extends Equatable {
  // Creates the base state.
  const TafsirState();

  // Lists the fields used for equality.
  @override
  List<Object?> get props => [];
}

// Tafsir has not started loading.
class TafsirInitial extends TafsirState {
  // Creates the initial state.
  const TafsirInitial();
}

// Surah and tafsir books are loading.
class TafsirLoading extends TafsirState {
  // Creates the loading state.
  const TafsirLoading();
}

// Surah and books are ready; the tafsir text itself may still be loading or have failed.
class TafsirSuccess extends TafsirState {
  final SurahTextModel surah;
  final int ayahNumber;
  final List<TafsirEditionModel> editions;
  final String selectedEdition;
  final TafsirModel? tafsir;
  final bool isTafsirLoading;
  final String? tafsirError;

  // Creates the success state.
  const TafsirSuccess({
    required this.surah,
    required this.ayahNumber,
    required this.editions,
    required this.selectedEdition,
    this.tafsir,
    this.isTafsirLoading = false,
    this.tafsirError,
  });

  // Returns the ayah currently explained.
  AyahModel get ayah => surah.ayahAt(ayahNumber);

  // Tells whether a previous ayah exists in the surah.
  bool get hasPrevious => ayahNumber > 1;

  // Tells whether a next ayah exists in the surah.
  bool get hasNext => ayahNumber < surah.ayahs.length;

  // Returns the selected tafsir book, if it is in the list.
  TafsirEditionModel? get selectedEditionModel {
    for (final e in editions) {
      if (e.identifier == selectedEdition) return e;
    }
    return null;
  }

  // Returns a copy with the given fields replaced.
  TafsirSuccess copyWith({
    int? ayahNumber,
    String? selectedEdition,
    TafsirModel? tafsir,
    bool? isTafsirLoading,
    String? tafsirError,
    bool clearTafsir = false,
  }) =>
      TafsirSuccess(
        surah: surah,
        ayahNumber: ayahNumber ?? this.ayahNumber,
        editions: editions,
        selectedEdition: selectedEdition ?? this.selectedEdition,
        tafsir: clearTafsir ? null : (tafsir ?? this.tafsir),
        isTafsirLoading: isTafsirLoading ?? this.isTafsirLoading,
        tafsirError: tafsirError,
      );

  // Lists the fields used for equality.
  @override
  List<Object?> get props => [surah, ayahNumber, editions, selectedEdition, tafsir, isTafsirLoading, tafsirError];
}

// Surah or tafsir books failed to load; message is a translation key.
class TafsirError extends TafsirState {
  final String message;

  // Creates the error state.
  const TafsirError(this.message);

  // Lists the fields used for equality.
  @override
  List<Object?> get props => [message];
}
