import 'package:equatable/equatable.dart';
import 'package:mishkat/features/reader/data/models/mushaf_ayah_model.dart';

// One ayah of the Uthmani text with its mushaf position.
class AyahModel extends Equatable {
  final int number;
  final int numberInSurah;
  final String text;
  final int juz;
  final int page;

  // Creates an ayah model.
  const AyahModel({
    required this.number,
    required this.numberInSurah,
    required this.text,
    required this.juz,
    required this.page,
  });

  // Parses an ayah from the API JSON and removes the byte-order mark Tanzil text may carry.
  factory AyahModel.fromJson(Map<String, dynamic> json) => AyahModel(
        number: json['number'] as int,
        numberInSurah: json['numberInSurah'] as int,
        text: (json['text'] as String).replaceAll('\uFEFF', '').trim(),
        juz: json['juz'] as int? ?? 1,
        page: json['page'] as int? ?? 1,
      );

  // Serializes the ayah for the local cache.
  Map<String, dynamic> toJson() => {
        'number': number,
        'numberInSurah': numberInSurah,
        'text': text,
        'juz': juz,
        'page': page,
      };

  // Builds a placeholder ayah for Skeletonizer loading states.
  factory AyahModel.dummy() => const AyahModel(
        number: 2,
        numberInSurah: 2,
        text: 'ٱلۡحَمۡدُ لِلَّهِ رَبِّ ٱلۡعَٰلَمِينَ',
        juz: 1,
        page: 1,
      );

  // Returns a copy with a different text.
  AyahModel copyWithText(String newText) =>
      AyahModel(number: number, numberInSurah: numberInSurah, text: newText, juz: juz, page: page);

  // Returns a copy with the text, page and juz of the printed mushaf.
  AyahModel copyWithMushaf(MushafAyahModel mushaf) =>
      AyahModel(number: number, numberInSurah: numberInSurah, text: mushaf.text, juz: mushaf.juz, page: mushaf.page);

  // Lists the fields used for equality.
  @override
  List<Object?> get props => [number, text];
}
