// Installed version against the latest published one, with the store link for this platform.
class AppUpdateModel {
  final String currentVersion;
  final String latestVersion;
  final String storeUrl;
  final bool forceUpdate;

  // Creates the update info.
  const AppUpdateModel({
    required this.currentVersion,
    required this.latestVersion,
    required this.storeUrl,
    required this.forceUpdate,
  });

  // Reads the update info from the values collected by the data source.
  factory AppUpdateModel.fromJson(Map<String, dynamic> json) => AppUpdateModel(
        currentVersion: (json['current_version'] as String? ?? '').trim(),
        latestVersion: (json['latest_version'] as String? ?? '').trim(),
        storeUrl: (json['store_url'] as String? ?? '').trim(),
        forceUpdate: json['force_update'] as bool? ?? false,
      );

  // Creates placeholder update info for skeleton loading.
  factory AppUpdateModel.dummy() =>
      const AppUpdateModel(currentVersion: '1.0.0', latestVersion: '1.0.1', storeUrl: '', forceUpdate: false);

  // Whether a newer version is published and there is a store link to open.
  bool get needsUpdate => storeUrl.isNotEmpty && _compareVersions(latestVersion, currentVersion) > 0;

  // Compares two dotted versions number by number, ignoring any build suffix.
  static int _compareVersions(String a, String b) {
    final left = _parts(a);
    final right = _parts(b);
    final length = left.length > right.length ? left.length : right.length;
    for (var i = 0; i < length; i++) {
      final l = i < left.length ? left[i] : 0;
      final r = i < right.length ? right[i] : 0;
      if (l != r) return l.compareTo(r);
    }
    return 0;
  }

  // Splits a version like "1.2.3+4" into its numeric parts [1, 2, 3].
  static List<int> _parts(String version) =>
      version.split('+').first.split('.').map((p) => int.tryParse(p.trim()) ?? 0).toList();
}
