import 'package:mishkat/core/api/end_points.dart';

// Identifies which surah to fetch and in which text edition.
class SurahTextParams {
  final int surahNumber;
  final String edition;

  // Creates the params with the Uthmani edition by default.
  const SurahTextParams({required this.surahNumber, this.edition = EndPoints.quranEdition});

  // Serializes the params; the API takes them as path segments.
  Map<String, dynamic> toJson() => {'surah': surahNumber, 'edition': edition};
}
