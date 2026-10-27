import 'package:flutter/material.dart';

// Holds every color used in the app, mapped to the Mishkat green-and-gold identity.
class ColorsManager {
  ColorsManager._();

  // Brand
  static const Color primary = Color(0xFF0F3D2E);
  static const Color primaryLight = Color(0xFFE7EFE9);
  static const Color primaryMiddle = Color(0xFF0A2A20);
  static const Color secondry = Color(0xFFC9A24A);
  static const Color secondryDark = Color(0xFF7A5C14);

  // Feedback
  static const Color red = Color(0xFFB3261E);
  static const Color redLight = Color(0xFFF9DEDC);

  // Neutrals
  static const Color grey = Color(0xFF5B6B63);
  static const Color greyLight = Color(0xFFE6DCC3);
  static const Color greyBackground = Color(0xFFF7F2E6);
  static const Color divider = Color(0xFFEAE1CB);
  static const Color track = Color(0xFFEFE7D4);
  static const Color darkLight = Color(0xFF3E4D46);
  static const Color mutedOnDark = Color(0xFFB9C8BF);
  static const Color black = Color(0xFF1B2A24);
  static const Color white = Color(0xFFFFFDF8);
  static const Color surface = Color(0xFFFFFDF8);
  static const Color onSurface = Color(0xFF1B2A24);
  static const Color transparent = Colors.transparent;

  // Extras kept for completeness of the shared palette
  static const Color blue = Color(0xFF2C5D8A);
  static const Color green = Color(0xFF2E7D4F);
  static const Color yellow = Color(0xFFC9A24A);
  static const Color purple = Color(0xFF6B4E8A);
  static const Color lightBlue = Color(0xFFDCE8F2);

  // Translucent overlays
  static const Color whiteOverlay = Color(0x0FFFFFFF);
  static const Color whiteBorder = Color(0x24FFFFFF);
  static const Color goldOverlay = Color(0x3DC9A24A);
  static const Color goldBorder = Color(0x73C9A24A);
  static const Color shadow = Color(0x1F0F3D2E);
}
