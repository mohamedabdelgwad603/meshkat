import 'package:audio_session/audio_session.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

// One playable item with its lock-screen metadata.
class AudioTrack {
  final String id;
  final String source;
  final bool isLocalFile;
  final String title;
  final String album;
  final String artist;

  // Creates a track from a URL or local file path.
  const AudioTrack({
    required this.id,
    required this.source,
    required this.isLocalFile,
    required this.title,
    required this.album,
    required this.artist,
  });
}

// Playback flags exposed to the app without leaking just_audio types.
class PlaybackStatus {
  final bool isPlaying;
  final bool isBuffering;
  final bool isCompleted;

  // Creates the playback status.
  const PlaybackStatus({required this.isPlaying, required this.isBuffering, required this.isCompleted});
}

// Wraps just_audio so the app has a single player with background and lock-screen support.
class AudioPlayerService {
  final AudioPlayer _player = AudioPlayer();

  // Configures the audio session for spoken-word playback.
  Future<void> init() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.speech());
  }

  // Emits play, buffering and completion changes in an app-level shape.
  Stream<PlaybackStatus> get statusStream => _player.playerStateStream.map((s) => PlaybackStatus(
        isPlaying: s.playing,
        isBuffering: s.processingState == ProcessingState.loading || s.processingState == ProcessingState.buffering,
        isCompleted: s.processingState == ProcessingState.completed,
      ));

  // Emits the position inside the current track.
  Stream<Duration> get positionStream => _player.positionStream;

  // Emits the duration of the current track.
  Stream<Duration?> get durationStream => _player.durationStream;

  // Emits the index of the current track in the playlist.
  Stream<int?> get currentIndexStream => _player.currentIndexStream;

  // Returns the index of the current track.
  int? get currentIndex => _player.currentIndex;

  // Returns the position inside the current track.
  Duration get position => _player.position;

  // Tells whether playback is running.
  bool get isPlaying => _player.playing;

  // Replaces the playlist and jumps to the given track and position.
  Future<void> setPlaylist(List<AudioTrack> tracks, {int initialIndex = 0, Duration initialPosition = Duration.zero}) {
    final sources = tracks.map((t) {
      final tag = MediaItem(id: t.id, title: t.title, album: t.album, artist: t.artist);
      return t.isLocalFile ? AudioSource.file(t.source, tag: tag) : AudioSource.uri(Uri.parse(t.source), tag: tag);
    }).toList();
    return _player.setAudioSources(sources, initialIndex: initialIndex, initialPosition: initialPosition);
  }

  // Starts or resumes playback without waiting for it to finish.
  void play() => _player.play();

  // Pauses playback.
  Future<void> pause() => _player.pause();

  // Stops playback and releases the decoder.
  Future<void> stop() => _player.stop();

  // Seeks to a position, optionally in another track.
  Future<void> seek(Duration position, {int? index}) => _player.seek(position, index: index);

  // Changes the playback speed.
  Future<void> setSpeed(double speed) => _player.setSpeed(speed);

  // Turns looping of the whole playlist on or off.
  Future<void> setLoopAll(bool loop) => _player.setLoopMode(loop ? LoopMode.all : LoopMode.off);
}
