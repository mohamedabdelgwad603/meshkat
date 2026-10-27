import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mishkat/config/themes/color_manager.dart';
import 'package:mishkat/features/reader/data/datasources/mushaf_script_local_data_source.dart';
import 'package:mishkat/features/reader/data/models/mushaf_line_model.dart';
import 'package:mishkat/features/reader/data/models/mushaf_model.dart';
import 'package:mishkat/features/reader/presentation/widgets/mushaf_page.dart';
import 'package:mishkat/features/reader/presentation/widgets/mushaf_text_line.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Temporary checks of the laid-out mushaf: line width stats, a fit check of every page and a few page images.
void main() {
  late MushafModel mushaf;

  // Loads the real fonts, translations and mushaf data once.
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    await EasyLocalization.ensureInitialized();
    for (final f in {
      'UthmanicHafs': ['assets/fonts/UthmanicHafs-v18.ttf'],
      'Amiri': ['assets/fonts/Amiri-Regular.ttf', 'assets/fonts/Amiri-Bold.ttf'],
      'IBMPlexSansArabic': ['assets/fonts/IBMPlexSansArabic-Regular.ttf', 'assets/fonts/IBMPlexSansArabic-Medium.ttf'],
    }.entries) {
      final loader = FontLoader(f.key);
      for (final path in f.value) {
        loader.addFont(rootBundle.load(path));
      }
      await loader.load();
    }
    mushaf = await MushafScriptLocalDataSourceImp().getMushaf();
  });

  // Wraps a page in the app's localization, screen sizing and theme.
  Widget host(Widget page) => EasyLocalization(
        supportedLocales: const [Locale('ar'), Locale('en')],
        path: 'assets/translations',
        startLocale: const Locale('ar'),
        fallbackLocale: const Locale('ar'),
        child: Builder(
          builder: (context) => ScreenUtilInit(
            designSize: const Size(390, 844),
            builder: (context, _) => MaterialApp(
              debugShowCheckedModeBanner: false,
              locale: context.locale,
              supportedLocales: context.supportedLocales,
              localizationsDelegates: context.localizationDelegates,
              home: Scaffold(
                backgroundColor: ColorsManager.greyBackground,
                body: Column(children: [const SizedBox(height: 125), Expanded(child: page)]),
              ),
            ),
          ),
        ),
      );

  // Prints the widths of every regular line at font size 100 when its spaces are halved.
  testWidgets('line width stats', (tester) async {
    const style = TextStyle(fontFamily: 'UthmanicHafs', fontSize: 100, height: 1, letterSpacing: 0);
    final space = (TextPainter(text: const TextSpan(text: ' ', style: style), textDirection: TextDirection.rtl)..layout()).width;
    final widths = <double>[];
    for (final page in mushaf.pages.where((p) => !p.isOpening)) {
      for (final line in page.lines.where((l) => l.type == MushafLineType.text)) {
        widths.add(measureMushafLine(line, style) - (line.words.length - 1) * space * 0.5);
      }
    }
    widths.sort();
    double at(double q) => widths[((widths.length - 1) * q).round()];
    // ignore: avoid_print
    print('space $space; halved-space widths: median ${at(0.5).round()} p75 ${at(0.75).round()} p90 ${at(0.9).round()} p95 ${at(0.95).round()} p99 ${at(0.99).round()} '
        'p99.9 ${at(0.999).round()} max ${widths.last.round()}');
  });

  const sizes = {
    'small-android': Size(360, 640),
    'iphone-se': Size(375, 667),
    'iphone-15': Size(393, 852),
    'pro-max': Size(430, 932),
    'ipad': Size(820, 1180),
  };
  for (final entry in sizes.entries) {
    // Lays out every page at one screen size and reports text that does not fit and the font sizes used.
    testWidgets('all pages fit on ${entry.key}', (tester) async {
      tester.view.physicalSize = entry.value * 3;
      tester.view.devicePixelRatio = 3;
      final index = ValueNotifier<int>(0);
      await tester.runAsync(() async {
        await tester.pumpWidget(host(ValueListenableBuilder<int>(
          valueListenable: index,
          builder: (_, i, __) => MushafPage(key: ValueKey(i), page: mushaf.pages[i], mushaf: mushaf, onAyahTap: (_, __) {}),
        )));
        await Future<void>.delayed(const Duration(milliseconds: 500));
      });
      await tester.pumpAndSettle();
      final problems = <String>[];
      final fontSizes = <String>{};
      var shrunk = 0;
      var centered = 0;
      for (var i = 0; i < mushaf.pages.length; i++) {
        index.value = i;
        await tester.pump();
        final error = tester.takeException();
        if (error != null) problems.add('page ${i + 1}: $error');
        shrunk += find.byType(FittedBox).evaluate().length;
        for (final paragraph in tester.renderObjectList<RenderParagraph>(find.byType(RichText))) {
          var isQuran = false;
          paragraph.text.visitChildren((span) {
            final style = span.style;
            if (style?.fontFamily == 'UthmanicHafs' && style?.fontSize != null) {
              fontSizes.add(style!.fontSize!.toStringAsFixed(2));
              isQuran = true;
            }
            return true;
          });
          if (isQuran && paragraph.textAlign == TextAlign.center && i > 1) centered++;
          final needed = paragraph.getMaxIntrinsicWidth(double.infinity);
          if (needed > paragraph.size.width + 0.5) {
            final text = paragraph.text.toPlainText();
            problems.add('page ${i + 1}: needs ${needed.toStringAsFixed(1)} has ${paragraph.size.width.toStringAsFixed(1)}: '
                '${text.length > 40 ? text.substring(0, 40) : text}');
          }
        }
      }
      // ignore: avoid_print
      print('${entry.key}: font sizes $fontSizes, shrunk $shrunk, centered $centered, ${problems.length} problems\n'
          '${problems.take(15).join('\n')}');
    });
  }

  for (final pageNumber in [2, 20, 77, 300, 604]) {
    // Renders one page at iPhone 15 size and saves it as an image.
    testWidgets('golden page $pageNumber', (tester) async {
      tester.view.physicalSize = const Size(1179, 2556);
      tester.view.devicePixelRatio = 3;
      await tester.runAsync(() async {
        await tester.pumpWidget(host(MushafPage(page: mushaf.pages[pageNumber - 1], mushaf: mushaf, onAyahTap: (_, __) {})));
        await Future<void>.delayed(const Duration(milliseconds: 500));
      });
      await tester.pumpAndSettle();
      await expectLater(find.byType(Scaffold), matchesGoldenFile('goldens/page_$pageNumber.png'));
    });
  }
}
