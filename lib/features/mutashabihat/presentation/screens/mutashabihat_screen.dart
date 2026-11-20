import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mishkat/config/routes/route_arguments.dart';
import 'package:mishkat/core/services/dependancy_injection_methods/init_di.dart';
import 'package:mishkat/features/mutashabihat/data/requests_params/ayah_mutashabihat_params.dart';
import 'package:mishkat/features/mutashabihat/presentation/cubit/mutashabihat_cubit.dart';
import 'package:mishkat/features/mutashabihat/presentation/widgets/mutashabihat_body.dart';

// Similar phrases of one ayah and every other ayah they appear in.
class MutashabihatScreen extends StatelessWidget {
  final MutashabihatArgs args;

  // Creates the screen for the given ayah.
  const MutashabihatScreen({super.key, required this.args});

  // Provides the cubit, loads the ayah and builds the body.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<MutashabihatCubit>()
        ..load(AyahMutashabihatParams(surahNumber: args.surahNumber, ayahNumber: args.ayahNumber)),
      child: const MutashabihatBody(),
    );
  }
}
