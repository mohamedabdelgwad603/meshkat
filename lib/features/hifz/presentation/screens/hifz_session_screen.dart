import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mishkat/core/services/dependancy_injection_methods/init_di.dart';
import 'package:mishkat/features/hifz/data/requests_params/hifz_session_params.dart';
import 'package:mishkat/features/hifz/presentation/cubit/hifz_session_cubit.dart';
import 'package:mishkat/features/hifz/presentation/widgets/hifz_session_body.dart';

// Listen-and-repeat session for a memorization range.
class HifzSessionScreen extends StatelessWidget {
  final HifzSessionParams params;

  // Creates the session screen for the given range.
  const HifzSessionScreen({super.key, required this.params});

  // Provides the session cubit, starts the session and builds the body.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<HifzSessionCubit>()..start(params),
      child: HifzSessionBody(params: params),
    );
  }
}
