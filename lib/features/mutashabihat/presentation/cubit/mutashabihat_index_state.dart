import 'package:equatable/equatable.dart';

// Base state of the list of ayahs that have similar phrases.
abstract class MutashabihatIndexState extends Equatable {
  // Creates the base state.
  const MutashabihatIndexState();

  // Lists the fields used for equality.
  @override
  List<Object?> get props => [];
}

// The index has not been loaded yet.
class MutashabihatIndexInitial extends MutashabihatIndexState {
  // Creates the initial state.
  const MutashabihatIndexInitial();
}

// The index is loading.
class MutashabihatIndexLoading extends MutashabihatIndexState {
  // Creates the loading state.
  const MutashabihatIndexLoading();
}

// The index is available.
class MutashabihatIndexSuccess extends MutashabihatIndexState {
  final Set<String> ayahKeys;

  // Creates the success state.
  const MutashabihatIndexSuccess(this.ayahKeys);

  // Tells whether the given ayah has similar phrases.
  bool has(int surahNumber, int ayahNumber) => ayahKeys.contains('$surahNumber:$ayahNumber');

  // Lists the fields used for equality.
  @override
  List<Object?> get props => [ayahKeys.length];
}

// The index failed to load; message is a translation key.
class MutashabihatIndexError extends MutashabihatIndexState {
  final String message;

  // Creates the error state.
  const MutashabihatIndexError(this.message);

  // Lists the fields used for equality.
  @override
  List<Object?> get props => [message];
}
