import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mishkat/core/services/dependancy_injection_methods/init_di.dart';
import 'package:mishkat/features/home/presentation/cubit/home_cubit.dart';
import 'package:mishkat/features/home/presentation/widgets/home_body.dart';

// Home tab: greeting, continue-reading card, shortcuts and the ayah of the day.
class HomeScreen extends StatelessWidget {
  // Creates the home screen.
  const HomeScreen({super.key});

  // Provides the home cubit and builds the body.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<HomeCubit>()..loadDailyAyah(),
      child: const HomeBody(),
    );
  }
}
