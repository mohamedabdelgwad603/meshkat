import 'package:equatable/equatable.dart';

// Base state of the splash screen.
abstract class SplashState extends Equatable {
  // Creates the base state.
  const SplashState();

  // Lists the fields used for equality.
  @override
  List<Object?> get props => [];
}

// The splash is being shown.
class SplashInitial extends SplashState {
  // Creates the initial state.
  const SplashInitial();
}

// The splash has finished and the app can move on.
class SplashFinished extends SplashState {
  // Creates the finished state.
  const SplashFinished();
}
