import 'package:flutter/material.dart';
import 'package:mishkat/features/bookmarks/presentation/widgets/saved_body.dart';

// Saved tab listing the bookmarked ayahs; uses the app-wide bookmarks cubit.
class SavedScreen extends StatelessWidget {
  // Creates the saved screen.
  const SavedScreen({super.key});

  // Builds the body.
  @override
  Widget build(BuildContext context) => const SavedBody();
}
