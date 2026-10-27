import 'package:flutter/material.dart';
import 'package:mishkat/core/utills/assets_manager.dart';

// Displays the gold Mishkat mark (star, niche and lamp).
class AppLogo extends StatelessWidget {
  final double size;

  // Creates the logo at the given size.
  const AppLogo({super.key, required this.size});

  // Builds the logo image.
  @override
  Widget build(BuildContext context) {
    return Image.asset(AssetsManager.logo, width: size, height: size, excludeFromSemantics: true);
  }
}
