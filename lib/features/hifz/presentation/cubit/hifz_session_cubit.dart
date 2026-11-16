import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mishkat/core/services/audio/audio_player_service.dart';
import 'package:mishkat/core/utills/text_manager.dart';
import 'package:mishkat/features/hifz/data/requests_params/hifz_session_params.dart';
import 'package:mishkat/features/hifz/domain/repo/hifz_repo.dart';
import 'package:mishkat/features/hifz/presentation/cubit/hifz_session_state.dart';

// Plays a memorization range: each ayah several times with a silent pause to recite, then the whole range.
class HifzSessionCubit extends Cubit<HifzSessionState> {
  final HifzRepo _repo;
  final AudioPlayerService _audio;

  final List<StreamSubscription<dynamic>> _subscriptions = [];
  HifzSessionParams? _params;
  HifzSessionData? _resumeData;
  Completer<bool>? _pendingPlay;
  bool _sawActive = false;
  int _run = 0;
  int? _loadedIndex;

  // Creates the cubit and listens to the shared audio player.
  HifzSessionCubit(this._repo, this._audio) : super(const HifzSessionInitial()) {
    _subscriptions
      ..add(_audio.statusStream.listen(_onStatus))
      ..add(_audio.ownerStream.listen(_onOwnerChanged));
  }

  // Returns the cubit provided above the given context.
  static HifzSessionCubit get(BuildContext context) => BlocProvider.of(context);

  // Loads the range and starts playing it from the first ayah.
  Future<void> start(HifzSessionParams params) async {
    _params = params;
    _resumeData = null;
    _cancelRun();
    if (isClosed) return;
    emit(const HifzSessionLoading());
    final result = await _repo.getSession(params);
    if (isClosed) return;
    result.fold(
      (failure) => emit(HifzSessionError(failure.message)),
      (session) {
        if (session.ayahs.isEmpty) {
          emit(const HifzSessionError(TextManager.errorUnknown));
          return;
        }
        _loadedIndex = null;
        emit(HifzSessionSuccess(HifzSessionData(session: session, settings: params.settings, isPlaying: true)));
        _runLoop();
      },
    );
  }

  // Continues from where playback failed, or reloads the range when it never loaded.
  Future<void> retry() async {
    final resume = _resumeData;
    if (resume == null) {
      final params = _params;
      if (params != null) await start(params);
      return;
    }
    _resumeData = null;
    _loadedIndex = null;
    if (isClosed) return;
    emit(HifzSessionSuccess(resume.copyWith(isPlaying: true, isBuffering: false, isRecitePause: false)));
    _runLoop();
  }

  // Pauses or resumes, restarting from the beginning when the session has finished.
  Future<void> togglePlay() async {
    final data = _data;
    if (data == null) return;
    if (data.stage == HifzStage.finished) return restart();
    if (data.isPlaying) {
      _update((d) => d.copyWith(isPlaying: false));
      await _audio.pause();
      return;
    }
    _update((d) => d.copyWith(isPlaying: true));
    if (_pendingPlay != null && _audio.owner == AudioOwner.hifz) {
      _audio.play();
    } else {
      _runLoop();
    }
  }

  // Starts the whole session again from the first ayah.
  Future<void> restart() => _jumpTo(0, stage: HifzStage.ayahRepeat);

  // Moves to the next ayah of the current stage.
  Future<void> next() async {
    final data = _data;
    if (data == null || data.stage == HifzStage.finished || data.isLastAyah) return;
    await _jumpTo(data.currentIndex + 1, stage: data.stage);
  }

  // Moves to the previous ayah of the current stage, or replays the first one.
  Future<void> previous() async {
    final data = _data;
    if (data == null || data.stage == HifzStage.finished) return;
    await _jumpTo((data.currentIndex - 1).clamp(0, data.session.ayahs.length - 1).toInt(), stage: data.stage);
  }

  // Plays the given ayah from its first repetition within the given stage.
  Future<void> _jumpTo(int index, {required HifzStage stage}) async {
    final data = _data;
    if (data == null) return;
    _cancelRun();
    final keepRound = stage == HifzStage.rangeReview && data.stage == HifzStage.rangeReview;
    _update((d) => d.copyWith(
          currentIndex: index,
          stage: stage,
          repetition: keepRound ? d.repetition : 1,
          isPlaying: true,
          isRecitePause: false,
        ));
    _runLoop();
  }

  // Plays the session step by step until it finishes, is cancelled or fails.
  Future<void> _runLoop() async {
    final run = ++_run;
    final settings = _data?.settings;
    if (settings == null) return;
    _audio.claim(AudioOwner.hifz);
    try {
      await _audio.setLoopAll(false);
      await _audio.setSpeed(settings.speed);
      while (run == _run && !isClosed) {
        final data = _data;
        if (data == null) return;
        if (data.stage == HifzStage.finished) {
          await _finish();
          return;
        }
        await _ensureLoaded(data);
        if (run != _run) return;
        _update((d) => d.copyWith(isRecitePause: false));
        if (!await _playOnce(run, silent: false)) return;
        if (data.stage == HifzStage.ayahRepeat && settings.recitePause) {
          _update((d) => d.copyWith(isRecitePause: true));
          if (!await _playOnce(run, silent: true)) return;
        }
        if (run != _run) return;
        _update((d) => d.advanced().copyWith(isRecitePause: false));
      }
    } catch (_) {
      if (run != _run || isClosed) return;
      _cancelRun();
      _loadedIndex = null;
      await _audio.pause();
      await _audio.setVolume(1);
      _resumeData = _data?.copyWith(isPlaying: false, isRecitePause: false);
      if (isClosed) return;
      emit(const HifzSessionError(TextManager.errorNoInternet));
    }
  }

  // Loads the current ayah's audio when another ayah is loaded.
  Future<void> _ensureLoaded(HifzSessionData data) async {
    if (_loadedIndex == data.currentIndex) return;
    final ayah = data.session.ayahs[data.currentIndex];
    _loadedIndex = null;
    await _audio.setPlaylist([
      AudioTrack(
        id: 'hifz-${ayah.surahNumber}-${ayah.ayahNumber}-${ayah.isLocalFile}',
        source: ayah.audioSource,
        isLocalFile: ayah.isLocalFile,
        title: '${data.session.surahName} · ${ayah.ayahNumber}',
        album: data.session.surahName,
        artist: data.session.reciterName,
      ),
    ]);
    _loadedIndex = data.currentIndex;
  }

  // Plays the loaded ayah once, muted for the recite pause, and returns false when it was cancelled.
  Future<bool> _playOnce(int run, {required bool silent}) async {
    await _audio.setVolume(silent ? 0 : 1);
    if (run != _run) return false;
    final completer = Completer<bool>();
    _pendingPlay = completer;
    _sawActive = false;
    await _audio.seek(Duration.zero);
    if (run != _run) return false;
    if (_data?.isPlaying ?? false) _audio.play();
    final completed = await completer.future;
    if (identical(_pendingPlay, completer)) _pendingPlay = null;
    if (silent) await _audio.setVolume(1);
    return completed && run == _run;
  }

  // Stops at the end of the session with the volume restored.
  Future<void> _finish() async {
    await _audio.pause();
    await _audio.setVolume(1);
    _loadedIndex = null;
    _update((d) => d.copyWith(isPlaying: false, isBuffering: false, isRecitePause: false));
  }

  // Mirrors buffering and completes the pending play once the ayah has really played to its end.
  void _onStatus(PlaybackStatus status) {
    if (_audio.owner != AudioOwner.hifz) return;
    final pending = _pendingPlay;
    if (pending != null && !pending.isCompleted) {
      if (!status.isCompleted) {
        _sawActive = true;
      } else if (_sawActive) {
        pending.complete(true);
      }
    }
    final data = _data;
    if (data != null && data.isBuffering != status.isBuffering) {
      _update((d) => d.copyWith(isBuffering: status.isBuffering));
    }
  }

  // Pauses the session when the regular player takes the shared audio back.
  void _onOwnerChanged(AudioOwner owner) {
    if (owner == AudioOwner.hifz) return;
    _cancelRun();
    _loadedIndex = null;
    _update((d) => d.copyWith(isPlaying: false, isBuffering: false, isRecitePause: false));
  }

  // Stops the running loop and releases any play it is waiting on.
  void _cancelRun() {
    _run++;
    final pending = _pendingPlay;
    _pendingPlay = null;
    if (pending != null && !pending.isCompleted) pending.complete(false);
  }

  // Returns the loaded session data, if any.
  HifzSessionData? get _data {
    final current = state;
    return current is HifzSessionSuccess ? current.data : null;
  }

  // Emits a modified copy of the session data.
  void _update(HifzSessionData Function(HifzSessionData) change) {
    final data = _data;
    if (data == null) return;
    if (isClosed) return;
    emit(HifzSessionSuccess(change(data)));
  }

  // Stops playback, restores the volume and cancels listeners when the session screen closes.
  @override
  Future<void> close() async {
    _cancelRun();
    for (final s in _subscriptions) {
      await s.cancel();
    }
    if (_audio.owner == AudioOwner.hifz) {
      await _audio.pause();
      await _audio.setVolume(1);
    }
    return super.close();
  }
}
