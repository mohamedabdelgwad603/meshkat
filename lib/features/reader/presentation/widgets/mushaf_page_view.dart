import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mishkat/features/reader/presentation/cubit/reader_cubit.dart';
import 'package:mishkat/features/reader/presentation/cubit/reader_state.dart';
import 'package:mishkat/features/reader/presentation/widgets/mushaf_page.dart';

// Horizontal pager of mushaf pages that swipes in reading direction.
class MushafPageView extends StatefulWidget {
  final ValueListenable<double> sheetHeight;

  // Creates the pager; each page can scroll up by the height of the ayah panel covering it.
  const MushafPageView({super.key, required this.sheetHeight});

  // Creates the pager state.
  @override
  State<MushafPageView> createState() => _MushafPageViewState();
}

// Owns the page controller opened on the initial page.
class _MushafPageViewState extends State<MushafPageView> {
  late final PageController _controller;

  // Opens the controller on the page where the requested ayah starts.
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
          itemCount: success.mushaf.pages.length,
          onPageChanged: cubit.onPageChanged,
          itemBuilder: (_, index) => _buildScrollablePage(
            MushafPage(
              page: success.mushaf.pages[index],
              mushaf: success.mushaf,
              selectedSurah: success.selectedSurah,
              selectedAyah: success.selectedAyah,
              onAyahTap: cubit.selectAyah,
            ),
          ),
        );
      },
    );
  }

  // Keeps the page at full screen height and adds room below it, the size of the ayah panel, so it can scroll above the panel.
  Widget _buildScrollablePage(Widget page) {
    return LayoutBuilder(
      builder: (context, constraints) => ValueListenableBuilder<double>(
        valueListenable: widget.sheetHeight,
        child: SizedBox(height: constraints.maxHeight, child: page),
        builder: (context, sheetHeight, child) => SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(children: [child!, SizedBox(height: sheetHeight)]),
        ),
      ),
    );
  }
}
