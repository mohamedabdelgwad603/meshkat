import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mishkat/config/routes/route_arguments.dart';
import 'package:mishkat/core/services/dependancy_injection_methods/init_di.dart';
import 'package:mishkat/features/reader/presentation/cubit/reader_cubit.dart';
import 'package:mishkat/features/reader/presentation/widgets/reader_body.dart';

// Mushaf reader that pages through a surah and offers per-ayah actions.
class ReaderScreen extends StatelessWidget {
  final ReaderArgs args;

  // Creates the reader for the given surah and ayah.
  const ReaderScreen({super.key, required this.args});

  // Provides the reader cubit and builds the body.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ReaderCubit>()..load(args.surahNumber, initialAyah: args.initialAyah),
      child: ReaderBody(args: args),
    );
  }
}
