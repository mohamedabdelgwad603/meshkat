import 'package:equatable/equatable.dart';

// How a memorization session repeats ayahs, remembered between sessions.
class HifzSettingsModel extends Equatable {
  final int ayahRepeat;
  final int rangeRepeat;
  final bool recitePause;
  final double speed;

  static const List<int> ayahRepeatOptions = [1, 3, 5, 7, 10];
  static const List<int> rangeRepeatOptions = [0, 1, 2, 3, 5];
  static const List<double> speedOptions = [0.75, 1.0, 1.25];

  // Creates the settings.
  const HifzSettingsModel({
    this.ayahRepeat = 3,
    this.rangeRepeat = 1,
    this.recitePause = true,
    this.speed = 1.0,
  });

  // Parses the settings from the local cache, falling back to defaults for unknown values.
  factory HifzSettingsModel.fromJson(Map<String, dynamic> json) {
    const defaults = HifzSettingsModel();
    final ayahRepeat = json['ayahRepeat'] as int? ?? defaults.ayahRepeat;
    final rangeRepeat = json['rangeRepeat'] as int? ?? defaults.rangeRepeat;
    final speed = (json['speed'] as num?)?.toDouble() ?? defaults.speed;
    return HifzSettingsModel(
      ayahRepeat: ayahRepeatOptions.contains(ayahRepeat) ? ayahRepeat : defaults.ayahRepeat,
      rangeRepeat: rangeRepeatOptions.contains(rangeRepeat) ? rangeRepeat : defaults.rangeRepeat,
      recitePause: json['recitePause'] as bool? ?? defaults.recitePause,
      speed: speedOptions.contains(speed) ? speed : defaults.speed,
    );
  }

  // Serializes the settings for the local cache.
  Map<String, dynamic> toJson() => {
        'ayahRepeat': ayahRepeat,
        'rangeRepeat': rangeRepeat,
        'recitePause': recitePause,
        'speed': speed,
      };

  // Returns a copy with the given fields replaced.
  HifzSettingsModel copyWith({int? ayahRepeat, int? rangeRepeat, bool? recitePause, double? speed}) =>
      HifzSettingsModel(
        ayahRepeat: ayahRepeat ?? this.ayahRepeat,
        rangeRepeat: rangeRepeat ?? this.rangeRepeat,
        recitePause: recitePause ?? this.recitePause,
        speed: speed ?? this.speed,
      );

  // Builds placeholder settings for Skeletonizer loading states.
  factory HifzSettingsModel.dummy() => const HifzSettingsModel();

  // Lists the fields used for equality.
  @override
  List<Object?> get props => [ayahRepeat, rangeRepeat, recitePause, speed];
}
