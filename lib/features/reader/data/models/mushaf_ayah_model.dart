// One ayah as printed in the King Fahd Complex Madani mushaf: its text, page and juz.
class MushafAyahModel {
  final String text;
  final int page;
  final int juz;

  // Creates the mushaf ayah.
  const MushafAyahModel({required this.text, required this.page, required this.juz});

  // Parses the ayah from the bundled mushaf JSON.
  factory MushafAyahModel.fromJson(Map<String, dynamic> json) => MushafAyahModel(
        text: json['text'] as String,
        page: json['page'] as int,
        juz: json['juz'] as int,
      );

  // Builds a placeholder ayah for Skeletonizer loading states.
  factory MushafAyahModel.dummy() =>
      const MushafAyahModel(text: 'ٱلۡحَمۡدُ لِلَّهِ رَبِّ ٱلۡعَٰلَمِينَ', page: 1, juz: 1);
}
