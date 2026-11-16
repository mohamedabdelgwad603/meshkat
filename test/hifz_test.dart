import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mishkat/core/errors/failure.dart';
import 'package:mishkat/core/services/audio/audio_player_service.dart';
import 'package:mishkat/features/hifz/data/models/hifz_ayah_model.dart';
import 'package:mishkat/features/hifz/data/models/hifz_session_model.dart';
import 'package:mishkat/features/hifz/data/models/hifz_settings_model.dart';
import 'package:mishkat/features/hifz/data/requests_params/hifz_session_params.dart';
import 'package:mishkat/features/hifz/domain/repo/hifz_repo.dart';
import 'package:mishkat/features/hifz/presentation/cubit/hifz_session_cubit.dart';
import 'package:mishkat/features/hifz/presentation/cubit/hifz_session_state.dart';
import 'package:mishkat/features/hifz/presentation/cubit/hifz_test_cubit.dart';
import 'package:mishkat/features/hifz/presentation/cubit/hifz_test_state.dart';
import 'package:mishkat/features/reader/data/models/mushaf_surah_model.dart';

// Player stand-in that finishes every play right away and logs what was heard.
class _FakeAudio implements AudioPlayerService {
  final _status = StreamController<PlaybackStatus>.broadcast();
  final _owners = StreamController<AudioOwner>.broadcast();
  final List<String> plays = [];
  AudioOwner _owner = AudioOwner.player;
  String? _loaded;
  double volume = 1;
  bool _playing = false;
  bool autoComplete = true;

  @override
  Stream<PlaybackStatus> get statusStream => _status.stream;
  @override
  Stream<Duration> get positionStream => const Stream.empty();
  @override
  Stream<Duration?> get durationStream => const Stream.empty();
  @override
  Stream<int?> get currentIndexStream => const Stream.empty();
  @override
  int? get currentIndex => 0;
  @override
  Duration get position => Duration.zero;
  @override
  bool get isPlaying => _playing;
  @override
  AudioOwner get owner => _owner;
  @override
  Stream<AudioOwner> get ownerStream => _owners.stream;

  @override
  void claim(AudioOwner owner) {
    if (_owner == owner) return;
    _owner = owner;
    _owners.add(owner);
  }

  @override
  Future<void> init() async {}
  @override
  Future<void> setPlaylist(List<AudioTrack> tracks, {int initialIndex = 0, Duration initialPosition = Duration.zero}) async {
    _loaded = tracks[initialIndex].id;
    _status.add(const PlaybackStatus(isPlaying: false, isBuffering: true, isCompleted: false));
  }

  @override
  Future<void> seek(Duration position, {int? index}) async =>
      _status.add(PlaybackStatus(isPlaying: _playing, isBuffering: false, isCompleted: false));

  @override
  void play() {
    _playing = true;
    plays.add('$_loaded@${volume == 0 ? 'silent' : 'audible'}');
    if (!autoComplete) return;
    scheduleMicrotask(() => _status.add(const PlaybackStatus(isPlaying: true, isBuffering: false, isCompleted: true)));
  }

  // Finishes the current play when auto-complete is off.
  void complete() => _status.add(const PlaybackStatus(isPlaying: true, isBuffering: false, isCompleted: true));

  @override
  Future<void> pause() async => _playing = false;
  @override
  Future<void> stop() async => _playing = false;
  @override
  Future<void> setSpeed(double speed) async {}
  @override
  Future<void> setLoopAll(bool loop) async {}
  @override
  Future<void> setVolume(double v) async => volume = v;
}

// Repository stand-in serving a fixed range and recording ratings.
class _FakeRepo implements HifzRepo {
  final int ayahCount;
  final Map<int, bool> rated = {};
  final _changes = StreamController<int>.broadcast();

  _FakeRepo(this.ayahCount);

  HifzSessionModel get _session => HifzSessionModel(
        surahName: 'سورة',
        surahEnglishName: 'Surah',
        reciterName: 'قارئ',
        ayahs: [
          for (var i = 1; i <= ayahCount; i++)
            HifzAyahModel(
              surahNumber: 67,
              ayahNumber: i,
              globalNumber: i,
              text: 'كلمة اولى ثانية',
              audioSource: 'a$i',
              isLocalFile: false,
            ),
        ],
      );

  @override
  Future<Either<Failure, HifzSessionModel>> getSession(HifzSessionParams params) async => Right(_session);
  @override
  Future<Either<Failure, HifzSessionModel>> getTestAyahs(HifzSessionParams params) async => Right(_session);
  @override
  Future<Either<Failure, List<MushafSurahModel>>> getSurahs() async => const Right([]);
  @override
  HifzSettingsModel getSettings() => const HifzSettingsModel();
  @override
  Future<Either<Failure, HifzSettingsModel>> saveSettings(HifzSettingsModel settings) async => Right(settings);
  @override
  Future<Either<Failure, Set<int>>> getMemorized(int surahNumber) async =>
      Right(rated.entries.where((e) => e.value).map((e) => e.key).toSet());
  @override
  Future<Either<Failure, Set<int>>> setMemorized(int surahNumber, int ayahNumber, bool memorized) async {
    rated[ayahNumber] = memorized;
    _changes.add(surahNumber);
    return getMemorized(surahNumber);
  }

  @override
  Stream<int> get memorizedChanges => _changes.stream;
}

// Waits until the session reaches the finished stage or the time runs out.
Future<HifzSessionData> _untilFinished(HifzSessionCubit cubit) async {
  for (var i = 0; i < 500; i++) {
    final state = cubit.state;
    if (state is HifzSessionSuccess && state.data.stage == HifzStage.finished && !state.data.isPlaying) {
      return state.data;
    }
    await Future<void>.delayed(Duration.zero);
  }
  fail('session did not finish');
}

// Builds params for a range with the given settings.
HifzSessionParams _params(HifzSettingsModel settings) =>
    HifzSessionParams(surahNumber: 67, fromAyah: 1, toAyah: 2, settings: settings);

// Checks the memorization flow: step order, the audio engine and the self-test.
void main() {
  group('HifzSessionData.advanced', () {
    HifzSessionData data(HifzSettingsModel s, int ayahs) => HifzSessionData(
          session: HifzSessionModel(
            surahName: '',
            surahEnglishName: '',
            reciterName: '',
            ayahs: List.generate(ayahs, (_) => HifzAyahModel.dummy()),
          ),
          settings: s,
        );

    test('repeats each ayah, then reviews the range, then finishes', () {
      var d = data(const HifzSettingsModel(ayahRepeat: 2, rangeRepeat: 2), 2);
      final steps = <String>[];
      while (d.stage != HifzStage.finished) {
        steps.add('${d.stage.name}:${d.currentIndex}:${d.repetition}');
        d = d.advanced();
      }
      expect(steps, [
        'ayahRepeat:0:1',
        'ayahRepeat:0:2',
        'ayahRepeat:1:1',
        'ayahRepeat:1:2',
        'rangeReview:0:1',
        'rangeReview:1:1',
        'rangeReview:0:2',
        'rangeReview:1:2',
      ]);
    });

    test('skips the range review for a single ayah or when it is off', () {
      expect(data(const HifzSettingsModel(ayahRepeat: 1, rangeRepeat: 3), 1).advanced().stage, HifzStage.finished);
      final off = data(const HifzSettingsModel(ayahRepeat: 1, rangeRepeat: 0), 2).advanced().advanced();
      expect(off.stage, HifzStage.finished);
    });
  });

  group('HifzSessionCubit', () {
    test('plays each ayah the chosen times with a silent recite pause, then the range once', () async {
      final audio = _FakeAudio();
      final cubit = HifzSessionCubit(_FakeRepo(2), audio);
      await cubit.start(_params(const HifzSettingsModel(ayahRepeat: 3, rangeRepeat: 1, recitePause: true)));
      await _untilFinished(cubit);
      const a1 = 'hifz-67-1-false', a2 = 'hifz-67-2-false';
      expect(audio.plays, [
        for (var i = 0; i < 3; i++) ...['$a1@audible', '$a1@silent'],
        for (var i = 0; i < 3; i++) ...['$a2@audible', '$a2@silent'],
        '$a1@audible',
        '$a2@audible',
      ]);
      expect(audio.volume, 1);
      expect(audio.owner, AudioOwner.hifz);
      await cubit.close();
    });

    test('without the recite pause every play is audible', () async {
      final audio = _FakeAudio();
      final cubit = HifzSessionCubit(_FakeRepo(2), audio);
      await cubit.start(_params(const HifzSettingsModel(ayahRepeat: 1, rangeRepeat: 0, recitePause: false)));
      await _untilFinished(cubit);
      expect(audio.plays, ['hifz-67-1-false@audible', 'hifz-67-2-false@audible']);
      await cubit.close();
    });

    test('pausing holds the session and resuming continues it', () async {
      final audio = _FakeAudio()..autoComplete = false;
      final cubit = HifzSessionCubit(_FakeRepo(1), audio);
      await cubit.start(_params(const HifzSettingsModel(ayahRepeat: 2, rangeRepeat: 0, recitePause: false)));
      await Future<void>.delayed(Duration.zero);
      expect(audio.plays.length, 1);
      await cubit.togglePlay();
      expect((cubit.state as HifzSessionSuccess).data.isPlaying, isFalse);
      await cubit.togglePlay();
      expect((cubit.state as HifzSessionSuccess).data.isPlaying, isTrue);
      audio.complete();
      await Future<void>.delayed(Duration.zero);
      await Future<void>.delayed(Duration.zero);
      expect((cubit.state as HifzSessionSuccess).data.repetition, 2);
      await cubit.close();
    });

    test('the regular player taking the audio back pauses the session', () async {
      final audio = _FakeAudio()..autoComplete = false;
      final cubit = HifzSessionCubit(_FakeRepo(2), audio);
      await cubit.start(_params(const HifzSettingsModel(ayahRepeat: 3, rangeRepeat: 0, recitePause: false)));
      await Future<void>.delayed(Duration.zero);
      audio.claim(AudioOwner.player);
      await Future<void>.delayed(Duration.zero);
      expect((cubit.state as HifzSessionSuccess).data.isPlaying, isFalse);
      await cubit.close();
    });

    test('closing restores the volume', () async {
      final audio = _FakeAudio()..autoComplete = false;
      final cubit = HifzSessionCubit(_FakeRepo(1), audio);
      await cubit.start(_params(const HifzSettingsModel(ayahRepeat: 1, recitePause: true)));
      audio.volume = 0;
      await cubit.close();
      expect(audio.volume, 1);
    });
  });

  group('HifzTestCubit', () {
    test('hides all but the first word, reveals and saves ratings', () async {
      final repo = _FakeRepo(2);
      final cubit = HifzTestCubit(repo);
      await cubit.load(_params(const HifzSettingsModel()));
      HifzTestData data() => (cubit.state as HifzTestSuccess).data;
      expect(data().revealedWords, [1, 1]);
      cubit.revealWord(0);
      expect(data().revealedWords[0], 2);
      cubit.revealAyah(0);
      expect(data().isFullyRevealed(0), isTrue);
      await cubit.rate(0, memorized: true);
      await cubit.rate(1, memorized: false);
      expect(data().memorizedCount, 1);
      expect(repo.rated, {1: true, 2: false});
      cubit.toggleHint();
      expect(data().revealedWords, [0, 0]);
      cubit.restart();
      expect(data().results, isEmpty);
      await cubit.close();
    });
  });

  test('settings fall back to defaults for unknown values', () {
    final s = HifzSettingsModel.fromJson({'ayahRepeat': 4, 'rangeRepeat': 2, 'speed': 3.0, 'recitePause': false});
    expect(s.ayahRepeat, 3);
    expect(s.rangeRepeat, 2);
    expect(s.speed, 1.0);
    expect(s.recitePause, isFalse);
  });
}
