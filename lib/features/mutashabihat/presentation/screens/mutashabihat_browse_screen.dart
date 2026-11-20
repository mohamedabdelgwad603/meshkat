import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mishkat/core/services/dependancy_injection_methods/init_di.dart';
import 'package:mishkat/features/mutashabihat/presentation/cubit/mutashabihat_browse_cubit.dart';
import 'package:mishkat/features/mutashabihat/presentation/widgets/mutashabihat_browse_body.dart';

// Every similar phrase of the Quran, searchable and filterable by surah.
class MutashabihatBrowseScreen extends StatelessWidget {
  // Creates the browse screen.
  const MutashabihatBrowseScreen({super.key});

  // Provides the browse cubit and builds the body.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<MutashabihatBrowseCubit>()..load(),
      child: const MutashabihatBrowseBody(),
    );
  }
}
