import 'package:mishkat/features/reader/data/models/mushaf_word_model.dart';

// Kinds of line a mushaf page is made of.
enum MushafLineType { text, surahHeader, basmala }

// One of the fifteen lines of a mushaf page.
class MushafLineModel {
  final MushafLineType type;
  final int? surahNumber;
  final List<MushafWordModel> words;

  // Creates the line.
  const MushafLineModel({required this.type, this.surahNumber, this.words = const []});

  // Parses the line from the bundled page layout JSON.
  factory MushafLineModel.fromJson(Map<String, dynamic> json) {
    switch (json['type'] as String) {
      case 'surah':
        return MushafLineModel(type: MushafLineType.surahHeader, surahNumber: json['surah'] as int);
      case 'basmala':
        return const MushafLineModel(type: MushafLineType.basmala);
      default:
        return MushafLineModel(
          type: MushafLineType.text,
          words: (json['words'] as List<dynamic>)
              .map((e) => MushafWordModel.fromJson(e as Map<String, dynamic>))
              .toList(),
        );
    }
  }

  // Builds a placeholder text line for Skeletonizer loading states.
  factory MushafLineModel.dummy() =>
      MushafLineModel(type: MushafLineType.text, words: List.generate(7, (_) => MushafWordModel.dummy()));
}
