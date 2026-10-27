import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mishkat/core/services/dependancy_injection_methods/init_di.dart';
import 'package:mishkat/features/splash/presentation/cubit/splash_cubit.dart';
import 'package:mishkat/features/splash/presentation/widgets/splash_body.dart';

// Shows the branded splash before opening the main layout.
class SplashScreen extends StatelessWidget {
  // Creates the splash screen.
  const SplashScreen({super.key});

  // Provides the splash cubit and builds the body.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<SplashCubit>()..start(),
      child: const SplashBody(),
    );
  }
}
