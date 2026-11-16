import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mishkat/config/routes/route_arguments.dart';
import 'package:mishkat/core/services/dependancy_injection_methods/init_di.dart';
import 'package:mishkat/features/hifz/presentation/cubit/hifz_setup_cubit.dart';
import 'package:mishkat/features/hifz/presentation/widgets/hifz_setup_body.dart';

// Memorization setup where the user picks a surah range and how to repeat it.
class HifzSetupScreen extends StatelessWidget {
  final HifzArgs? args;

  // Creates the setup screen, optionally starting at a surah and ayah.
  const HifzSetupScreen({super.key, this.args});

  // Provides the setup cubit and builds the body.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<HifzSetupCubit>()..load(surahNumber: args?.surahNumber ?? 1, fromAyah: args?.fromAyah ?? 1),
      child: const HifzSetupBody(),
    );
  }
}
