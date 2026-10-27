import 'package:equatable/equatable.dart';

// One of the thirty juz with the surah and ayah where it starts.
class JuzModel extends Equatable {
  final int number;
  final int surahNumber;
  final int ayahNumber;

  // Creates a juz model.
  const JuzModel({required this.number, required this.surahNumber, required this.ayahNumber});

  // Parses a juz from a [surah, ayah] pair at the given index.
  factory JuzModel.fromJson(Map<String, dynamic> json) => JuzModel(
        number: json['number'] as int,
        surahNumber: json['surah'] as int,
        ayahNumber: json['ayah'] as int,
      );

  // Builds a placeholder juz for Skeletonizer loading states.
  factory JuzModel.dummy() => const JuzModel(number: 1, surahNumber: 1, ayahNumber: 1);

  // Lists the fields used for equality.
  @override
  List<Object?> get props => [number];
}
