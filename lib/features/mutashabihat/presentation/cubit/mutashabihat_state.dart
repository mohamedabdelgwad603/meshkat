import 'package:equatable/equatable.dart';
import 'package:mishkat/features/mutashabihat/data/models/mutashabih_phrase_details_model.dart';

// Base state of an ayah's mutashabihat page.
abstract class MutashabihatState extends Equatable {
  // Creates the base state.
  const MutashabihatState();

  // Lists the fields used for equality.
  @override
  List<Object?> get props => [];
}

// The page has not loaded yet.
class MutashabihatInitial extends MutashabihatState {
  // Creates the initial state.
  const MutashabihatInitial();
}

// The phrases are loading.
class MutashabihatLoading extends MutashabihatState {
  // Creates the loading state.
  const MutashabihatLoading();
}

// The ayah and its similar phrases are available.
class MutashabihatSuccess extends MutashabihatState {
  final MutashabihatResultModel result;

  // Creates the success state.
  const MutashabihatSuccess(this.result);

  // Lists the fields used for equality.
  @override
  List<Object?> get props => [result.ayah.surahNumber, result.ayah.ayahNumber];
}

// The page failed to load; message is a translation key.
class MutashabihatError extends MutashabihatState {
  final String message;

  // Creates the error state.
  const MutashabihatError(this.message);

  // Lists the fields used for equality.
  @override
  List<Object?> get props => [message];
}
