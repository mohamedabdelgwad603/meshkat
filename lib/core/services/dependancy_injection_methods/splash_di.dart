import 'package:mishkat/core/services/dependancy_injection_methods/init_di.dart';
import 'package:mishkat/features/splash/presentation/cubit/splash_cubit.dart';

// Registers the splash screen dependencies.
void setupSplashDi() {
  getIt.registerFactory(() => SplashCubit());
}
