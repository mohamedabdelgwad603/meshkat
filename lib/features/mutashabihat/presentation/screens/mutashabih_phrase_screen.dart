import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mishkat/config/routes/route_arguments.dart';
import 'package:mishkat/core/services/dependancy_injection_methods/init_di.dart';
import 'package:mishkat/features/mutashabihat/data/requests_params/mutashabih_phrase_params.dart';
import 'package:mishkat/features/mutashabihat/presentation/cubit/mutashabih_phrase_cubit.dart';
import 'package:mishkat/features/mutashabihat/presentation/widgets/mutashabih_phrase_body.dart';

// One similar phrase with every ayah it appears in.
class MutashabihPhraseScreen extends StatelessWidget {
  final MutashabihPhraseArgs args;

  // Creates the screen for the given phrase.
  const MutashabihPhraseScreen({super.key, required this.args});

  // Provides the phrase cubit and builds the body.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<MutashabihPhraseCubit>()..load(MutashabihPhraseParams(phraseId: args.phraseId)),
      child: const MutashabihPhraseBody(),
    );
  }
}
