import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mishkat/core/services/dependancy_injection_methods/init_di.dart';
import 'package:mishkat/features/hifz/data/requests_params/hifz_session_params.dart';
import 'package:mishkat/features/hifz/presentation/cubit/hifz_test_cubit.dart';
import 'package:mishkat/features/hifz/presentation/widgets/hifz_test_body.dart';

// Self-test where the ayahs of a range are hidden and revealed word by word.
class HifzTestScreen extends StatelessWidget {
  final HifzSessionParams params;

  // Creates the test screen for the given range.
  const HifzTestScreen({super.key, required this.params});

  // Provides the test cubit, loads the range and builds the body.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<HifzTestCubit>()..load(params),
      child: const HifzTestBody(),
    );
  }
}
