import 'package:equatable/equatable.dart';
import 'package:mishkat/features/reflections/data/models/reflection_model.dart';

// Base state of the reflection notebook.
abstract class ReflectionsState extends Equatable {
  // Creates the base state.
  const ReflectionsState();

  // Lists the fields used for equality.
  @override
  List<Object?> get props => [];
}

// Reflections have not been loaded yet.
class ReflectionsInitial extends ReflectionsState {
  // Creates the initial state.
  const ReflectionsInitial();
}

// Reflections are loading from storage.
class ReflectionsLoading extends ReflectionsState {
  // Creates the loading state.
  const ReflectionsLoading();
}

// Reflections are available.
class ReflectionsSuccess extends ReflectionsState {
  final List<ReflectionModel> reflections;

  // Creates the success state.
  const ReflectionsSuccess(this.reflections);

  // Returns the reflection written on the given ayah, if any.
  ReflectionModel? find(int surah, int ayah) => reflections.where((r) => r.matches(surah, ayah)).firstOrNull;

  // Lists the fields used for equality.
  @override
  List<Object?> get props => [reflections];
}

// Reflections failed to load; message is a translation key.
class ReflectionsError extends ReflectionsState {
  final String message;

  // Creates the error state.
  const ReflectionsError(this.message);

  // Lists the fields used for equality.
  @override
  List<Object?> get props => [message];
}
