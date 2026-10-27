import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mishkat/core/services/dependancy_injection_methods/init_di.dart';
import 'package:mishkat/features/surahs/presentation/cubit/surahs_cubit.dart';
import 'package:mishkat/features/surahs/presentation/widgets/surahs_body.dart';

// Mushaf index tab: search plus surahs, juz and bookmarks lists.
class SurahsScreen extends StatelessWidget {
  // Creates the index screen.
  const SurahsScreen({super.key});

  // Provides the surahs cubit and builds the body.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<SurahsCubit>()..loadSurahs(),
      child: const SurahsBody(),
    );
  }
}
