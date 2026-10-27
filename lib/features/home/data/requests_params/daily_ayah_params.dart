import 'package:mishkat/core/api/end_points.dart';

// Picks the ayah of the day from the date so every user sees the same ayah each day.
class DailyAyahParams {
  static const int _totalAyahs = 6236;
  final int dayIndex;
  final String edition;

  // Creates the params for the given day index.
  const DailyAyahParams({required this.dayIndex, this.edition = EndPoints.quranEdition});

  // Creates the params for today.
  factory DailyAyahParams.today() {
    final now = DateTime.now();
    final day = DateTime.utc(now.year, now.month, now.day).millisecondsSinceEpoch ~/ Duration.millisecondsPerDay;
    return DailyAyahParams(dayIndex: day);
  }

  // Returns the global ayah number (1-6236) for the day, spread out with a prime step.
  int get ayahNumber => (dayIndex * 97) % _totalAyahs + 1;

  // Serializes the params.
  Map<String, dynamic> toJson() => {'reference': ayahNumber, 'edition': edition};
}
