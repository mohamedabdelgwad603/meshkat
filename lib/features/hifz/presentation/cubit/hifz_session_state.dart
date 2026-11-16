import 'package:equatable/equatable.dart';
import 'package:mishkat/features/hifz/data/models/hifz_session_model.dart';
import 'package:mishkat/features/hifz/data/models/hifz_settings_model.dart';

// Parts of a session: repeating each ayah, reviewing the whole range, then done.
enum HifzStage { ayahRepeat, rangeReview, finished }

// Where a memorization session is and what the player is doing.
class HifzSessionData extends Equatable {
  final HifzSessionModel session;
  final HifzSettingsModel settings;
  final int currentIndex;
  final HifzStage stage;
  final int repetition;
  final bool isPlaying;
  final bool isBuffering;
  final bool isRecitePause;

  // Creates the session data.
  const HifzSessionData({
    required this.session,
    required this.settings,
    this.currentIndex = 0,
    this.stage = HifzStage.ayahRepeat,
    this.repetition = 1,
    this.isPlaying = false,
    this.isBuffering = false,
    this.isRecitePause = false,
  });

  // Returns how many repetitions the current stage has.
  int get stageRepetitions => stage == HifzStage.rangeReview ? settings.rangeRepeat : settings.ayahRepeat;

  // Tells whether the last ayah of the range is playing.
  bool get isLastAyah => currentIndex == session.ayahs.length - 1;

  // Returns the position after the current play: the next repetition, ayah, stage or the end.
  HifzSessionData advanced() {
    final last = session.ayahs.length - 1;
    if (stage == HifzStage.ayahRepeat) {
      if (repetition < settings.ayahRepeat) return copyWith(repetition: repetition + 1);
      if (currentIndex < last) return copyWith(currentIndex: currentIndex + 1, repetition: 1);
      if (settings.rangeRepeat > 0 && last > 0) {
        return copyWith(stage: HifzStage.rangeReview, currentIndex: 0, repetition: 1);
      }
      return copyWith(stage: HifzStage.finished);
    }
    if (stage == HifzStage.rangeReview) {
      if (currentIndex < last) return copyWith(currentIndex: currentIndex + 1);
      if (repetition < settings.rangeRepeat) return copyWith(currentIndex: 0, repetition: repetition + 1);
    }
    return copyWith(stage: HifzStage.finished);
  }

  // Returns a copy with the given fields replaced.
  HifzSessionData copyWith({
    int? currentIndex,
    HifzStage? stage,
    int? repetition,
    bool? isPlaying,
    bool? isBuffering,
    bool? isRecitePause,
  }) =>
      HifzSessionData(
        session: session,
        settings: settings,
        currentIndex: currentIndex ?? this.currentIndex,
        stage: stage ?? this.stage,
        repetition: repetition ?? this.repetition,
        isPlaying: isPlaying ?? this.isPlaying,
        isBuffering: isBuffering ?? this.isBuffering,
        isRecitePause: isRecitePause ?? this.isRecitePause,
      );

  // Lists the fields used for equality.
  @override
  List<Object?> get props =>
      [session, settings, currentIndex, stage, repetition, isPlaying, isBuffering, isRecitePause];
}

// Base state of a memorization session.
abstract class HifzSessionState extends Equatable {
  // Creates the base state.
  const HifzSessionState();

  // Lists the fields used for equality.
  @override
  List<Object?> get props => [];
}

// The session has not started yet.
class HifzSessionInitial extends HifzSessionState {
  // Creates the initial state.
  const HifzSessionInitial();
}

// The range text and audio are loading.
class HifzSessionLoading extends HifzSessionState {
  // Creates the loading state.
  const HifzSessionLoading();
}

// The session is running, paused or finished.
class HifzSessionSuccess extends HifzSessionState {
  final HifzSessionData data;

  // Creates the success state.
  const HifzSessionSuccess(this.data);

  // Lists the fields used for equality.
  @override
  List<Object?> get props => [data];
}

// The session could not load or play; message is a translation key.
class HifzSessionError extends HifzSessionState {
  final String message;

  // Creates the error state.
  const HifzSessionError(this.message);

  // Lists the fields used for equality.
  @override
  List<Object?> get props => [message];
}
