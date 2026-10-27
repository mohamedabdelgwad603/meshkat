import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat/features/reader/presentation/cubit/reader_cubit.dart';
import 'package:mishkat/features/reader/presentation/cubit/reader_state.dart';
import 'package:mishkat/features/reader/presentation/widgets/mushaf_page.dart';

// Horizontal pager of mushaf pages that swipes in reading direction.
class MushafPageView extends StatefulWidget {
  // Creates the pager.
  const MushafPageView({super.key});

  // Creates the pager state.
  @override
  State<MushafPageView> createState() => _MushafPageViewState();
}

// Owns the page controller opened on the initial page.
class _MushafPageViewState extends State<MushafPageView> {
  late final PageController _controller;

  // Opens the controller on the page holding the requested ayah.
  @override
  void initState() {
    super.initState();
    final state = ReaderCubit.get(context).state as ReaderSuccess;
    _controller = PageController(initialPage: state.initialPageIndex);
  }

  // Releases the controller.
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Builds one mushaf page per item.
  @override
  Widget build(BuildContext context) {
    final cubit = ReaderCubit.get(context);
    return BlocBuilder<ReaderCubit, ReaderState>(
      buildWhen: (a, b) => b is ReaderSuccess,
      builder: (context, state) {
        final success = state as ReaderSuccess;
        return PageView.builder(
          controller: _controller,
          itemCount: success.pages.length,
          onPageChanged: cubit.onPageChanged,
          itemBuilder: (_, index) => MushafPage(
            surah: success.surah,
            ayahs: success.pages[index],
            isFirstPage: index == 0,
            selectedAyah: success.selectedAyah,
            bottomPadding: success.selectedAyah == null ? 32.h : 360.h,
            onAyahTap: cubit.selectAyah,
          ),
        );
      },
    );
  }
}
