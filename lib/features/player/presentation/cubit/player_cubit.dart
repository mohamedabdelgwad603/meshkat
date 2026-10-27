import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mishkat/core/services/audio/audio_player_service.dart';
import 'package:mishkat/core/utills/text_manager.dart';
import 'package:mishkat/features/player/data/models/ayah_audio_model.dart';
import 'package:mishkat/features/player/data/models/reciter_model.dart';
import 'package:mishkat/features/player/data/requests_params/surah_audio_params.dart';
import 'package:mishkat/features/player/domain/repo/player_repo.dart';
import 'package:mishkat/features/player/presentation/cubit/player_state.dart';
import 'package:mishkat/features/reader/data/models/surah_text_model.dart';
import 'package:mishkat/features/reader/data/requests_params/surah_text_params.dart';
import 'package:mishkat/features/reader/domain/repo/reader_repo.dart';

// App-wide recitation player: playlist of ayahs, repeat, speed, sleep timer and downloads.
class PlayerCubit extends Cubit<PlayerState> {
  final PlayerRepo _repo;
  final ReaderRepo _readerRepo;
  final AudioPlayerService _audio;

  final List<StreamSubscription<dynamic>> _subscriptions = [];
  Timer? _sleepTimer;
  int? _lastIndex;
  int _playsOfCurrent = 1;
  bool _manualJump = false;
  double _lastReportedProgress = 0;
  int? _pendingSurah;
  bool _isCompleted = false;

  static const List<double> _speeds = [1.0, 1.25, 1.5, 0.75];
  static const List<int> _repeats = [1, 3, 5];
  static const List<int> _sleepSteps = [0, 15, 30, 60];

  // Creates the cubit and listens to the audio service.
  PlayerCubit(this._repo, this._readerRepo, this._audio) : super(const PlayerInitial()) {
    _subscriptions
      ..add(_audio.statusStream.listen(_onStatus))
      ..add(_audio.currentIndexStream.listen(_onIndex));
  }

  // Returns the cubit provided above the given context.
  static PlayerCubit get(BuildContext context) => BlocProvider.of(context);

  // Emits the position inside the current ayah.
  Stream<Duration> get positionStream => _audio.positionStream;

  // Emits the duration of the current ayah.
  Stream<Duration?> get durationStream => _audio.durationStream;

  // Opens a surah at an ayah, keeps the current one when nothing new is requested, or loads the fallback surah.
  Future<void> open({int? surahNumber, int startAyah = 1, int fallbackSurah = 1}) async {
    final current = state;
    if (surahNumber == null) {
      if (current is PlayerSuccess || current is PlayerLoading) return;
      return _loadSurah(fallbackSurah, startIndex: 0, autoPlay: false);
    }
    if (current is PlayerSuccess && current.data.surah.number == surahNumber) {
      await jumpToAyah(startAyah);
      _audio.play();
      return;
    }
    await _loadSurah(surahNumber, startIndex: startAyah - 1, autoPlay: true);
  }

  // Retries loading the last requested surah.
  Future<void> retry() => _loadSurah(_pendingSurah ?? 1, startIndex: 0, autoPlay: false);

  // Plays or pauses, restarting from the first ayah when the surah has finished.
  Future<void> togglePlay() async {
    final data = _data;
    if (data == null) return;
    if (_audio.isPlaying && !_isCompleted) {
      await _audio.pause();
      return;
    }
    if (_isCompleted) {
      _manualJump = true;
      await _audio.seek(Duration.zero, index: 0);
    }
    _audio.play();
  }

  // Skips to the next ayah.
  Future<void> next() async {
    final data = _data;
    if (data == null || data.currentIndex >= data.totalAyahs - 1) return;
    _manualJump = true;
    await _audio.seek(Duration.zero, index: data.currentIndex + 1);
  }

  // Restarts the current ayah, or goes to the previous one when near its start.
  Future<void> previous() async {
    final data = _data;
    if (data == null) return;
    if (_audio.position > const Duration(seconds: 3) || data.currentIndex == 0) {
      await _audio.seek(Duration.zero, index: data.currentIndex);
    } else {
      _manualJump = true;
      await _audio.seek(Duration.zero, index: data.currentIndex - 1);
    }
  }

  // Jumps to an ayah of the loaded surah.
  Future<void> jumpToAyah(int ayahNumber) async {
    final data = _data;
    if (data == null) return;
    final target = (ayahNumber - 1).clamp(0, data.totalAyahs - 1).toInt();
    if (target != data.currentIndex) _manualJump = true;
    await _audio.seek(Duration.zero, index: target);
  }

  // Seeks inside the current ayah.
  Future<void> seekTo(Duration position) => _audio.seek(position);

  // Cycles the playback speed.
  Future<void> cycleSpeed() async {
    final data = _data;
    if (data == null) return;
    final next = _speeds[(_speeds.indexOf(data.speed) + 1) % _speeds.length];
    await _audio.setSpeed(next);
    _update((d) => d.copyWith(speed: next));
  }

  // Cycles how many times each ayah is repeated.
  void cycleRepeat() {
    final data = _data;
    if (data == null) return;
    final next = _repeats[(_repeats.indexOf(data.repeatTimes) + 1) % _repeats.length];
    _playsOfCurrent = 1;
    _update((d) => d.copyWith(repeatTimes: next));
  }

  // Turns looping of the whole surah on or off.
  Future<void> toggleLoopSurah() async {
    final data = _data;
    if (data == null) return;
    await _audio.setLoopAll(!data.loopSurah);
    _update((d) => d.copyWith(loopSurah: !d.loopSurah));
  }

  // Cycles the sleep timer between off, 15, 30 and 60 minutes.
  void cycleSleepTimer() {
    final data = _data;
    if (data == null) return;
    final next = _sleepSteps[(_sleepSteps.indexOf(data.sleepMinutes) + 1) % _sleepSteps.length];
    _sleepTimer?.cancel();
    if (next > 0) {
      _sleepTimer = Timer(Duration(minutes: next), () async {
        await _audio.pause();
        _update((d) => d.copyWith(sleepMinutes: 0));
      });
    }
    _update((d) => d.copyWith(sleepMinutes: next));
  }

  // Switches reciter, remembers the choice and resumes from the same ayah.
  Future<void> changeReciter(ReciterModel reciter) async {
    final data = _data;
    await _repo.saveSelectedReciter(reciter.identifier);
    if (data == null || data.reciter == reciter) return;
    await _loadSurah(data.surah.number, startIndex: data.currentIndex, autoPlay: data.isPlaying);
  }

  // Loads the reciter list when it is still empty.
  Future<void> loadReciters() async {
    final data = _data;
    if (data == null || data.reciters.isNotEmpty) return;
    final result = await _repo.getReciters();
    result.fold((_) {}, (list) => _update((d) => d.copyWith(reciters: list)));
  }

  // Downloads the surah for offline listening and switches playback to the local files.
  Future<void> downloadSurah() async {
    final data = _data;
    if (data == null || data.isDownloading || data.isDownloaded) return;
    _lastReportedProgress = 0;
    _update((d) => d.copyWith(downloadProgress: 0));
    final result = await _repo.downloadSurah(data.reciter.identifier, data.ayahs, onProgress: _onDownloadProgress);
    await result.fold(
      (failure) async => _update((d) => d.copyWith(clearDownload: true)),
      (_) async {
        final latest = _data;
        if (latest == null) return;
        final wasPlaying = _audio.isPlaying;
        await _setPlaylist(latest.surah, latest.reciter, latest.ayahs, latest.currentIndex, _audio.position);
        if (wasPlaying) _audio.play();
        _update((d) => d.copyWith(clearDownload: true, isDownloaded: true));
      },
    );
  }

  // Fetches text and audio for a surah and loads it into the audio service.
  Future<void> _loadSurah(int surahNumber, {required int startIndex, required bool autoPlay}) async {
    final prev = _data;
    _pendingSurah = surahNumber;
    if (isClosed) return;
    emit(const PlayerLoading());

    final textResult = await _readerRepo.getSurahText(SurahTextParams(surahNumber: surahNumber));
    final recitersResult = await _repo.getReciters();
    final reciters = recitersResult.getOrElse(() => const <ReciterModel>[]);
    final reciterId = _repo.getSelectedReciter();
    final reciter = reciters.firstWhere(
      (r) => r.identifier == reciterId,
      orElse: () => ReciterModel(identifier: reciterId, name: ReciterModel.dummy().name, englishName: ''),
    );
    final audioResult = await _repo.getSurahAudio(SurahAudioParams(surahNumber: surahNumber, reciter: reciter.identifier));
    if (isClosed) return;

    String? error;
    SurahTextModel? surah;
    List<AyahAudioModel>? ayahs;
    textResult.fold((f) => error = f.message, (s) => surah = s);
    audioResult.fold((f) => error ??= f.message, (a) => ayahs = a);
    if (error != null || surah == null || ayahs == null || ayahs!.isEmpty) {
      emit(PlayerError(error ?? TextManager.errorUnknown));
      return;
    }
    final loadedSurah = surah!;
    final loadedAyahs = ayahs!;
    final index = startIndex.clamp(0, loadedAyahs.length - 1).toInt();

    try {
      final isDownloaded = await _setPlaylist(loadedSurah, reciter, loadedAyahs, index, Duration.zero);
      final speed = prev?.speed ?? 1;
      final loop = prev?.loopSurah ?? false;
      await _audio.setSpeed(speed);
      await _audio.setLoopAll(loop);
      _lastIndex = index;
      _playsOfCurrent = 1;
      if (isClosed) return;
      emit(PlayerSuccess(PlayerData(
        surah: loadedSurah,
        reciter: reciter,
        reciters: reciters,
        ayahs: loadedAyahs,
        currentIndex: index,
        speed: speed,
        loopSurah: loop,
        repeatTimes: prev?.repeatTimes ?? 1,
        sleepMinutes: prev?.sleepMinutes ?? 0,
        isDownloaded: isDownloaded,
      )));
      if (autoPlay) _audio.play();
    } catch (_) {
      if (isClosed) return;
      emit(const PlayerError(TextManager.errorNoInternet));
    }
  }

  // Builds the playlist from local files where available and returns true when all are local.
  Future<bool> _setPlaylist(
    SurahTextModel surah,
    ReciterModel reciter,
    List<AyahAudioModel> ayahs,
    int index,
    Duration position,
  ) async {
    final localFiles = (await _repo.getLocalFiles(reciter.identifier, ayahs)).getOrElse(() => List.filled(ayahs.length, null));
    final tracks = [
      for (var i = 0; i < ayahs.length; i++)
        AudioTrack(
          id: '${reciter.identifier}-${ayahs[i].number}',
          source: localFiles[i] ?? ayahs[i].audioUrl,
          isLocalFile: localFiles[i] != null,
          title: '${surah.shortName} · ${ayahs[i].numberInSurah}',
          album: surah.name,
          artist: reciter.name,
        ),
    ];
    await _audio.setPlaylist(tracks, initialIndex: index, initialPosition: position);
    return localFiles.every((f) => f != null);
  }

  // Mirrors play and buffering flags and repeats the last ayah when the surah ends.
  void _onStatus(PlaybackStatus status) {
    _isCompleted = status.isCompleted;
    final data = _data;
    if (data == null) return;
    if (status.isCompleted && data.currentIndex == data.totalAyahs - 1 && _playsOfCurrent < data.repeatTimes) {
      _playsOfCurrent++;
      _audio.seek(Duration.zero, index: data.currentIndex).then((_) => _audio.play());
      return;
    }
    _update((d) => d.copyWith(isPlaying: status.isPlaying && !status.isCompleted, isBuffering: status.isBuffering));
  }

  // Tracks the current ayah and replays it until it was heard the chosen number of times.
  void _onIndex(int? index) {
    final data = _data;
    if (index == null || data == null) return;
    final advancedNaturally = !_manualJump && _lastIndex != null && index == _lastIndex! + 1;
    if (advancedNaturally && _playsOfCurrent < data.repeatTimes) {
      _playsOfCurrent++;
      _audio.seek(Duration.zero, index: _lastIndex);
      return;
    }
    if (index != _lastIndex) _playsOfCurrent = 1;
    _manualJump = false;
    _lastIndex = index;
    _update((d) => d.copyWith(currentIndex: index));
  }

  // Emits download progress at most once per percent.
  void _onDownloadProgress(double progress) {
    if (progress - _lastReportedProgress < 0.01 && progress < 1) return;
    _lastReportedProgress = progress;
    _update((d) => d.copyWith(downloadProgress: progress));
  }

  // Returns the loaded data, if any.
  PlayerData? get _data {
    final current = state;
    return current is PlayerSuccess ? current.data : null;
  }

  // Emits a modified copy of the loaded data.
  void _update(PlayerData Function(PlayerData) change) {
    final data = _data;
    if (data == null) return;
    if (isClosed) return;
    emit(PlayerSuccess(change(data)));
  }

  // Cancels listeners and timers when the cubit is closed.
  @override
  Future<void> close() {
    for (final s in _subscriptions) {
      s.cancel();
    }
    _sleepTimer?.cancel();
    return super.close();
  }
}
