import 'package:mishkat/features/reader/data/models/mushaf_line_model.dart';
import 'package:mishkat/features/reader/data/models/mushaf_word_model.dart';

// One page of the Madani mushaf with its lines laid out as printed.
class MushafPageModel {
  final int number;
  final int juz;
  final List<MushafLineModel> lines;

  // Creates the page.
  const MushafPageModel({required this.number, required this.juz, required this.lines});

  // Parses the page from the bundled page layout JSON.
  factory MushafPageModel.fromJson(Map<String, dynamic> json, int number) => MushafPageModel(
        number: number,
        juz: json['juz'] as int,
        lines: (json['lines'] as List<dynamic>)
            .map((e) => MushafLineModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  // Builds a placeholder fifteen-line page for Skeletonizer loading states.
  factory MushafPageModel.dummy() =>
      MushafPageModel(number: 1, juz: 1, lines: List.generate(15, (_) => MushafLineModel.dummy()));

  // Returns the first word printed on the page.
  MushafWordModel get firstWord => lines.expand((l) => l.words).first;

  // Tells whether this is one of the two decorated opening pages with fewer, centered lines.
  bool get isOpening => number <= 2;
}
