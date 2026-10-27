import 'package:equatable/equatable.dart';
import 'package:mishkat/features/player/data/models/ayah_audio_model.dart';
import 'package:mishkat/features/player/data/models/reciter_model.dart';
import 'package:mishkat/features/reader/data/models/ayah_model.dart';
import 'package:mishkat/features/reader/data/models/surah_text_model.dart';

// Everything the player screen shows for the loaded surah.
class PlayerData extends Equatable {
  final SurahTextModel surah;
  final ReciterModel reciter;
  final List<ReciterModel> reciters;
  final List<AyahAudioModel> ayahs;
  final int currentIndex;
  final bool isPlaying;
  final bool isBuffering;
  final double speed;
  final int repeatTimes;
  final bool loopSurah;
  final int sleepMinutes;
  final double? downloadProgress;
  final bool isDownloaded;

  // Creates the player data.
  const PlayerData({
    required this.surah,
    required this.reciter,
    required this.reciters,
    required this.ayahs,
    this.currentIndex = 0,
    this.isPlaying = false,
    this.isBuffering = false,
    this.speed = 1,
    this.repeatTimes = 1,
    this.loopSurah = false,
    this.sleepMinutes = 0,
    this.downloadProgress,
    this.isDownloaded = false,
  });

  // Returns the ayah currently playing.
  AyahModel get currentAyah => surah.ayahAt(currentIndex + 1);

  // Returns the number of ayahs in the surah.
  int get totalAyahs => ayahs.length;

  // Tells whether a download is running.
  bool get isDownloading => downloadProgress != null;

  // Returns a copy with the given fields replaced; pass clearDownload to end the download state.
  PlayerData copyWith({
    ReciterModel? reciter,
    List<ReciterModel>? reciters,
    int? currentIndex,
    bool? isPlaying,
    bool? isBuffering,
    double? speed,
    int? repeatTimes,
    bool? loopSurah,
    int? sleepMinutes,
    double? downloadProgress,
    bool clearDownload = false,
    bool? isDownloaded,
  }) =>
      PlayerData(
        surah: surah,
        reciter: reciter ?? this.reciter,
        reciters: reciters ?? this.reciters,
        ayahs: ayahs,
        currentIndex: currentIndex ?? this.currentIndex,
        isPlaying: isPlaying ?? this.isPlaying,
        isBuffering: isBuffering ?? this.isBuffering,
        speed: speed ?? this.speed,
        repeatTimes: repeatTimes ?? this.repeatTimes,
        loopSurah: loopSurah ?? this.loopSurah,
        sleepMinutes: sleepMinutes ?? this.sleepMinutes,
        downloadProgress: clearDownload ? null : (downloadProgress ?? this.downloadProgress),
        isDownloaded: isDownloaded ?? this.isDownloaded,
      );

  // Builds placeholder data for Skeletonizer loading states.
  factory PlayerData.dummy() => PlayerData(
        surah: SurahTextModel.dummy(),
        reciter: ReciterModel.dummy(),
        reciters: const [],
        ayahs: List.generate(7, (_) => AyahAudioModel.dummy()),
      );

  // Lists the fields used for equality.
  @override
  List<Object?> get props => [
        surah,
        reciter,
        reciters,
        ayahs,
        currentIndex,
        isPlaying,
        isBuffering,
        speed,
        repeatTimes,
        loopSurah,
        sleepMinutes,
        downloadProgress,
        isDownloaded,
      ];
}

// Base state of the audio player.
abstract class PlayerState extends Equatable {
  // Creates the base state.
  const PlayerState();

  // Lists the fields used for equality.
  @override
  List<Object?> get props => [];
}

// Nothing has been loaded into the player.
class PlayerInitial extends PlayerState {
  // Creates the initial state.
  const PlayerInitial();
}

// A surah's recitation is loading.
class PlayerLoading extends PlayerState {
  // Creates the loading state.
  const PlayerLoading();
}

// A surah is loaded into the player.
class PlayerSuccess extends PlayerState {
  final PlayerData data;

  // Creates the success state.
  const PlayerSuccess(this.data);

  // Lists the fields used for equality.
  @override
  List<Object?> get props => [data];
}

// Loading the recitation failed; message is a translation key.
class PlayerError extends PlayerState {
  final String message;

  // Creates the error state.
  const PlayerError(this.message);

  // Lists the fields used for equality.
  @override
  List<Object?> get props => [message];
}
