import 'package:mishkat/features/hifz/data/models/hifz_settings_model.dart';

// The surah range to memorize and how to repeat it.
class HifzSessionParams {
  final int surahNumber;
  final int fromAyah;
  final int toAyah;
  final HifzSettingsModel settings;

  // Creates the params.
  const HifzSessionParams({
    required this.surahNumber,
    required this.fromAyah,
    required this.toAyah,
    this.settings = const HifzSettingsModel(),
  });

  // Serializes the params.
  Map<String, dynamic> toJson() => {
        'surahNumber': surahNumber,
        'fromAyah': fromAyah,
        'toAyah': toAyah,
        'settings': settings.toJson(),
      };
}
