import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mishkat/config/routes/route_arguments.dart';
import 'package:mishkat/core/services/dependancy_injection_methods/init_di.dart';
import 'package:mishkat/features/tafsir/presentation/cubit/tafsir_cubit.dart';
import 'package:mishkat/features/tafsir/presentation/widgets/tafsir_body.dart';

// Full tafsir of an ayah with a choice of tafsir books and ayah navigation.
class TafsirScreen extends StatelessWidget {
  final TafsirArgs args;

  // Creates the tafsir screen for the given ayah.
  const TafsirScreen({super.key, required this.args});

  // Provides the tafsir cubit and builds the body.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<TafsirCubit>()..init(args.surahNumber, args.ayahNumber),
      child: TafsirBody(args: args),
    );
  }
}
