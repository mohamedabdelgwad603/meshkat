import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mishkat/features/splash/presentation/cubit/splash_state.dart';

// Keeps the splash on screen for a short moment, then signals that it is done.
class SplashCubit extends Cubit<SplashState> {
  static const Duration displayDuration = Duration(milliseconds: 2500);

  // Creates the cubit in its initial state.
  SplashCubit() : super(const SplashInitial());

  // Returns the cubit provided above the given context.
  static SplashCubit get(BuildContext context) => BlocProvider.of(context);

  // Waits for the display duration and then emits the finished state.
  Future<void> start() async {
    await Future<void>.delayed(displayDuration);
    if (isClosed) return;
    emit(const SplashFinished());
  }
}
