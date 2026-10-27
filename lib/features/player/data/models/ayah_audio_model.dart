import 'package:equatable/equatable.dart';

// The audio file of one ayah for one reciter.
class AyahAudioModel extends Equatable {
  final int number;
  final int numberInSurah;
  final String audioUrl;

  // Creates the ayah audio model.
  const AyahAudioModel({required this.number, required this.numberInSurah, required this.audioUrl});

  // Parses an ayah audio entry from the /surah/{n}/{reciter} JSON.
  factory AyahAudioModel.fromJson(Map<String, dynamic> json) => AyahAudioModel(
        number: json['number'] as int,
        numberInSurah: json['numberInSurah'] as int,
        audioUrl: (json['audio'] as String? ?? '').replaceFirst('http://', 'https://'),
      );

  // Serializes the entry for the local cache.
  Map<String, dynamic> toJson() => {'number': number, 'numberInSurah': numberInSurah, 'audio': audioUrl};

  // Builds a placeholder for Skeletonizer loading states.
  factory AyahAudioModel.dummy() => const AyahAudioModel(
        number: 1,
        numberInSurah: 1,
        audioUrl: 'https://cdn.islamic.network/quran/audio/128/ar.alafasy/1.mp3',
      );

  // Lists the fields used for equality.
  @override
  List<Object?> get props => [number, audioUrl];
}
