import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mishkat/config/routes/route_arguments.dart';
import 'package:mishkat/config/themes/color_manager.dart';
import 'package:mishkat/core/utills/widgets/state_message_view.dart';
import 'package:mishkat/features/reader/data/models/surah_text_model.dart';
import 'package:mishkat/features/reader/presentation/cubit/reader_cubit.dart';
import 'package:mishkat/features/reader/presentation/cubit/reader_state.dart';
import 'package:mishkat/features/reader/presentation/widgets/ayah_actions_sheet.dart';
import 'package:mishkat/features/reader/presentation/widgets/mushaf_page.dart';
import 'package:mishkat/features/reader/presentation/widgets/mushaf_page_view.dart';
import 'package:mishkat/features/reader/presentation/widgets/reader_top_bar.dart';
import 'package:skeletonizer/skeletonizer.dart';

// Reader layout: top bar, mushaf pages and the selected-ayah panel.
class ReaderBody extends StatelessWidget {
  final ReaderArgs args;

  // Creates the body.
  const ReaderBody({super.key, required this.args});

  // Builds the layout for the current reader state.
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: ColorsManager.greyBackground,
        body: SafeArea(
          bottom: false,
          child: BlocBuilder<ReaderCubit, ReaderState>(
            buildWhen: (a, b) => a.runtimeType != b.runtimeType,
            builder: (context, state) {
              if (state is ReaderError) {
                return Column(
                  children: [
                    const ReaderTopBar(),
                    Expanded(
                      child: StateMessageView(
                        message: state.message,
                        onRetry: () => ReaderCubit.get(context).load(args.surahNumber, initialAyah: args.initialAyah),
                      ),
                    ),
                  ],
                );
              }
              if (state is! ReaderSuccess) return const _ReaderSkeleton();
              return const Stack(
                children: [
                  Column(
                    children: [
                      ReaderTopBar(),
                      Expanded(child: MushafPageView()),
                    ],
                  ),
                  Align(alignment: Alignment.bottomCenter, child: AyahActionsSheet()),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

// Placeholder page shown while the surah loads.
class _ReaderSkeleton extends StatelessWidget {
  // Creates the skeleton.
  const _ReaderSkeleton();

  // Builds a skeletonized dummy page.
  @override
  Widget build(BuildContext context) {
    final dummy = SurahTextModel.dummy();
    return Column(
      children: [
        const ReaderTopBar(),
        Expanded(
          child: Skeletonizer(
            child: MushafPage(surah: dummy, ayahs: dummy.ayahs, isFirstPage: true, onAyahTap: (_) {}),
          ),
        ),
      ],
    );
  }
}
