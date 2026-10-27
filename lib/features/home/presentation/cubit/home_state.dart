import 'package:equatable/equatable.dart';
import 'package:mishkat/features/home/data/models/daily_ayah_model.dart';

// Base state of the home screen's daily ayah.
abstract class HomeState extends Equatable {
  // Creates the base state.
  const HomeState();

  // Lists the fields used for equality.
  @override
  List<Object?> get props => [];
}

// Daily ayah has not started loading.
class HomeInitial extends HomeState {
  // Creates the initial state.
  const HomeInitial();
}

// Daily ayah is loading.
class HomeLoading extends HomeState {
  // Creates the loading state.
  const HomeLoading();
}

// Daily ayah is ready.
class HomeSuccess extends HomeState {
  final DailyAyahModel dailyAyah;

  // Creates the success state.
  const HomeSuccess(this.dailyAyah);

  // Lists the fields used for equality.
  @override
  List<Object?> get props => [dailyAyah];
}

// Daily ayah failed to load; message is a translation key.
class HomeError extends HomeState {
  final String message;

  // Creates the error state.
  const HomeError(this.message);

  // Lists the fields used for equality.
  @override
  List<Object?> get props => [message];
}
