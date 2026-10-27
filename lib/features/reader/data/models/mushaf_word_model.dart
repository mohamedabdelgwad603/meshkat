// One word on a mushaf line, or the ornament that ends an ayah.
class MushafWordModel {
  final int surah;
  final int ayah;
  final String text;
  final bool isAyahEnd;

  // Creates the word.
  const MushafWordModel({required this.surah, required this.ayah, required this.text, this.isAyahEnd = false});

  // Parses the word from the bundled page layout JSON.
  factory MushafWordModel.fromJson(Map<String, dynamic> json) => MushafWordModel(
        surah: json['s'] as int,
        ayah: json['a'] as int,
        text: json['t'] as String,
        isAyahEnd: json['end'] as bool? ?? false,
      );

  // Builds a placeholder word for Skeletonizer loading states.
  factory MushafWordModel.dummy() => const MushafWordModel(surah: 1, ayah: 1, text: 'ٱلۡحَمۡدُ');
}
