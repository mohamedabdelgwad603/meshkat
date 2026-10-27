import 'package:flutter/material.dart';
import 'package:mishkat/config/routes/page_name.dart';
import 'package:mishkat/config/routes/route_arguments.dart';
import 'package:mishkat/features/layout/presentation/screens/main_layout_screen.dart';
import 'package:mishkat/features/player/presentation/screens/player_screen.dart';
import 'package:mishkat/features/reader/presentation/screens/reader_screen.dart';
import 'package:mishkat/features/settings/presentation/screens/credits_screen.dart';
import 'package:mishkat/features/splash/presentation/screens/splash_screen.dart';
import 'package:mishkat/features/tafsir/presentation/screens/tafsir_screen.dart';

// Resolves route names to screens with a shared transition.
class RouteManager {
  RouteManager._();

  // Builds the route for the requested page name.
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case PageName.splash:
        return _getPageTransition(const SplashScreen(), settings);
      case PageName.mainLayout:
        return _getPageTransition(const MainLayoutScreen(), settings);
      case PageName.reader:
        return _getPageTransition(ReaderScreen(args: settings.arguments as ReaderArgs), settings);
      case PageName.tafsir:
        return _getPageTransition(TafsirScreen(args: settings.arguments as TafsirArgs), settings);
      case PageName.player:
        final args = settings.arguments as PlayerArgs?;
        return _getPageTransition(PlayerScreen(args: args), settings, fromBottom: true);
      case PageName.credits:
        return _getPageTransition(const CreditsScreen(), settings);
      default:
        return _getPageTransition(const MainLayoutScreen(), settings);
    }
  }

  // Wraps a screen in a fade-and-slide page transition.
  static PageRouteBuilder<dynamic> _getPageTransition(Widget screen, RouteSettings settings, {bool fromBottom = false}) {
    return PageRouteBuilder<dynamic>(
      settings: settings,
      transitionDuration: const Duration(milliseconds: 320),
      reverseTransitionDuration: const Duration(milliseconds: 260),
      pageBuilder: (_, __, ___) => screen,
      transitionsBuilder: (context, animation, _, child) {
        final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
        final isRtl = Directionality.of(context) == TextDirection.rtl;
        final begin = fromBottom ? const Offset(0, 0.12) : Offset(isRtl ? -0.08 : 0.08, 0);
        return FadeTransition(
          opacity: curved,
          child: SlideTransition(position: Tween(begin: begin, end: Offset.zero).animate(curved), child: child),
        );
      },
    );
  }
}
