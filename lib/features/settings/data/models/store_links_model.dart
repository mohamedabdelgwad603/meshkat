// The app's Google Play and App Store links, each empty when it is not set yet.
class StoreLinksModel {
  final String android;
  final String ios;

  // Creates the links.
  const StoreLinksModel({required this.android, required this.ios});

  // Reads the links collected from Remote Config, dropping any that do not point to a page.
  factory StoreLinksModel.fromJson(Map<String, dynamic> json) => StoreLinksModel(
        android: _usable(json['android'] as String? ?? ''),
        ios: _usable(json['ios'] as String? ?? ''),
      );

  // Builds placeholder links for Skeletonizer loading states.
  factory StoreLinksModel.dummy() => const StoreLinksModel(android: '', ios: '');

  // Tells whether at least one store link is set.
  bool get hasAny => android.isNotEmpty || ios.isNotEmpty;

  // Returns the link when it is an http(s) address with a page path, otherwise an empty string.
  static String _usable(String url) {
    final uri = Uri.tryParse(url.trim());
    final valid = uri != null && uri.hasScheme && uri.host.isNotEmpty && uri.pathSegments.any((s) => s.isNotEmpty);
    return valid ? url.trim() : '';
  }
}
