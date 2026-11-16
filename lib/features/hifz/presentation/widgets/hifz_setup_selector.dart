import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mishkat/features/hifz/presentation/cubit/hifz_setup_cubit.dart';
import 'package:mishkat/features/hifz/presentation/cubit/hifz_setup_state.dart';

// Rebuilds its child from the setup data, using placeholder data while loading.
class HifzSetupSelector extends StatelessWidget {
  final Widget Function(BuildContext context, HifzSetupData data) builder;

  // Creates the selector with the given builder.
  const HifzSetupSelector({super.key, required this.builder});

  // Builds the child for the current setup data.
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HifzSetupCubit, HifzSetupState>(
      builder: (context, state) => builder(context, state is HifzSetupSuccess ? state.data : HifzSetupData.dummy()),
    );
  }
}
