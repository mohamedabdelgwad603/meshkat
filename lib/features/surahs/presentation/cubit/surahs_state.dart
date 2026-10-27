import 'package:equatable/equatable.dart';
import 'package:mishkat/features/surahs/data/models/juz_model.dart';
import 'package:mishkat/features/surahs/data/models/surah_model.dart';

// Base state of the surah index.
abstract class SurahsState extends Equatable {
  // Creates the base state.
  const SurahsState();

  // Lists the fields used for equality.
  @override
  List<Object?> get props => [];
}

// Index has not started loading.
class SurahsInitial extends SurahsState {
  // Creates the initial state.
  const SurahsInitial();
}

// Surah list is loading.
class SurahsLoading extends SurahsState {
  // Creates the loading state.
  const SurahsLoading();
}

// Surah list loaded, with the current search query applied.
class SurahsSuccess extends SurahsState {
  final List<SurahModel> surahs;
  final List<SurahModel> filtered;
  final List<JuzModel> juzList;
  final String query;

  // Creates the success state.
  const SurahsSuccess({required this.surahs, required this.filtered, required this.juzList, this.query = ''});

  // Returns the surah with the given number.
  SurahModel surahByNumber(int number) => surahs.firstWhere((s) => s.number == number);

  // Lists the fields used for equality.
  @override
  List<Object?> get props => [surahs, filtered, juzList, query];
}

// Surah list failed to load; message is a translation key.
class SurahsError extends SurahsState {
  final String message;

  // Creates the error state.
  const SurahsError(this.message);

  // Lists the fields used for equality.
  @override
  List<Object?> get props => [message];
}
