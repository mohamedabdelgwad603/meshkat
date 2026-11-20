import 'package:flutter/material.dart';
import 'package:mishkat/features/reader/presentation/widgets/ayah_actions_sheet.dart';
import 'package:mishkat/features/reader/presentation/widgets/mushaf_page_view.dart';
import 'package:mishkat/features/reader/presentation/widgets/reader_top_bar.dart';

// Top bar and mushaf pages with the ayah panel on top, letting pages scroll above the panel while it is open.
class ReaderContent extends StatefulWidget {
  // Creates the content.
  const ReaderContent({super.key});

  // Creates the content state.
  @override
  State<ReaderContent> createState() => _ReaderContentState();
}

// Holds the panel height shared between the panel and the pages.
class _ReaderContentState extends State<ReaderContent> {
  final ValueNotifier<double> _sheetHeight = ValueNotifier(0);

  // Releases the height notifier.
  @override
  void dispose() {
    _sheetHeight.dispose();
    super.dispose();
  }

  // Builds the pages under the panel.
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            const ReaderTopBar(),
            Expanded(child: MushafPageView(sheetHeight: _sheetHeight)),
          ],
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: AyahActionsSheet(onHeightChanged: (height) => _sheetHeight.value = height),
        ),
      ],
    );
  }
}
