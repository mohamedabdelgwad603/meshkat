import 'package:equatable/equatable.dart';

// One ayah of a memorization range with its printed text and audio.
class HifzAyahModel extends Equatable {
  final int surahNumber;
  final int ayahNumber;
  final int globalNumber;
  final String text;
  final String audioSource;
  final bool isLocalFile;

  // Creates the ayah.
  const HifzAyahModel({
    required this.surahNumber,
    required this.ayahNumber,
    required this.globalNumber,
    required this.text,
    required this.audioSource,
    required this.isLocalFile,
  });

  // Reads the ayah from the values collected by the repository.
  factory HifzAyahModel.fromJson(Map<String, dynamic> json) => HifzAyahModel(
        surahNumber: json['surahNumber'] as int,
        ayahNumber: json['ayahNumber'] as int,
        globalNumber: json['globalNumber'] as int,
        text: json['text'] as String,
        audioSource: json['audioSource'] as String,
        isLocalFile: json['isLocalFile'] as bool? ?? false,
      );

  // Builds a placeholder ayah for Skeletonizer loading states.
  factory HifzAyahModel.dummy() => const HifzAyahModel(
        surahNumber: 1,
        ayahNumber: 2,
        globalNumber: 2,
        text: 'ٱلۡحَمۡدُ لِلَّهِ رَبِّ ٱلۡعَٰلَمِينَ',
        audioSource: '',
        isLocalFile: false,
      );

  // Returns the words of the ayah in reading order, without the quarter and prostration marks.
  List<String> get words => text.trim().split(RegExp(r'\s+')).where((w) => w != '۞' && w != '۩').toList();

  // Lists the fields used for equality.
  @override
  List<Object?> get props => [surahNumber, ayahNumber, audioSource];
}
