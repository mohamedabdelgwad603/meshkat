import 'package:flutter/material.dart';

// Navigation helpers so screens never call Navigator.of(context) directly.
extension BuildContextExtention on BuildContext {
  // Pushes a named route with optional arguments.
  Future<T?> pushNamed<T extends Object?>(String routeName, {Object? arguments}) =>
      Navigator.of(this).pushNamed<T>(routeName, arguments: arguments);

  // Replaces the current route with a named route.
  Future<T?> pushReplacementNamed<T extends Object?, TO extends Object?>(String routeName, {Object? arguments}) =>
      Navigator.of(this).pushReplacementNamed<T, TO>(routeName, arguments: arguments);

  // Pushes a named route and removes routes until the predicate returns true.
  Future<T?> pushNamedAndRemoveUntil<T extends Object?>(
    String routeName, {
    required RoutePredicate predicate,
    Object? arguments,
  }) =>
      Navigator.of(this).pushNamedAndRemoveUntil<T>(routeName, predicate, arguments: arguments);

  // Pops the current route with an optional result.
  void pop<T extends Object?>([T? result]) => Navigator.of(this).pop<T>(result);

  // Shows a short floating message with a translated key.
  void showSnack(Widget content) {
    ScaffoldMessenger.of(this)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: content, duration: const Duration(seconds: 2)));
  }
}
