import 'package:equatable/equatable.dart';
import 'package:mishkat/features/mutashabihat/data/models/mutashabih_phrase_details_model.dart';

// Base state of one phrase's page.
abstract class MutashabihPhraseState extends Equatable {
  // Creates the base state.
  const MutashabihPhraseState();

  // Lists the fields used for equality.
  @override
  List<Object?> get props => [];
}

// The page has not loaded yet.
class MutashabihPhraseInitial extends MutashabihPhraseState {
  // Creates the initial state.
  const MutashabihPhraseInitial();
}

// The phrase is loading.
class MutashabihPhraseLoading extends MutashabihPhraseState {
  // Creates the loading state.
  const MutashabihPhraseLoading();
}

// The phrase and its ayahs are available.
class MutashabihPhraseSuccess extends MutashabihPhraseState {
  final MutashabihPhraseDetailsModel phrase;

  // Creates the success state.
  const MutashabihPhraseSuccess(this.phrase);

  // Lists the fields used for equality.
  @override
  List<Object?> get props => [phrase.text, phrase.ayahCount];
}

// The page failed to load; message is a translation key.
class MutashabihPhraseError extends MutashabihPhraseState {
  final String message;

  // Creates the error state.
  const MutashabihPhraseError(this.message);

  // Lists the fields used for equality.
  @override
  List<Object?> get props => [message];
}
