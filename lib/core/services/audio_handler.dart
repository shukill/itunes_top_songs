import 'package:audio_service/audio_service.dart';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';

import '../../domain/entities/song.dart';

class AudioPlayerHandler extends BaseAudioHandler with SeekHandler {
  final AudioPlayer _player = AudioPlayer();
  final BehaviorSubject<Song?> _currentSongSubject = BehaviorSubject<Song?>();
  final BehaviorSubject<Duration> _durationSubject =
      BehaviorSubject<Duration>.seeded(Duration.zero);

  // Expose a stream of the current song
  Stream<Song?> get currentSongStream => _currentSongSubject.stream;
  Song? get currentSong => _currentSongSubject.valueOrNull;

  // Expose a stream of the current duration
  Stream<Duration> get durationStream => _durationSubject.stream;

  AudioPlayerHandler() {
    // Forward player events to clients
    _player.playbackEventStream.listen((event) {
      final playing = _player.playing;
      playbackState.add(playbackState.value.copyWith(
        controls: [
          MediaControl.skipToPrevious,
          if (playing) MediaControl.pause else MediaControl.play,
          MediaControl.skipToNext,
        ],
        systemActions: const {
          MediaAction.seek,
          MediaAction.seekForward,
          MediaAction.seekBackward,
        },
        androidCompactActionIndices: const [0, 1, 2],
        processingState: const {
          ProcessingState.idle: AudioProcessingState.idle,
          ProcessingState.loading: AudioProcessingState.loading,
          ProcessingState.buffering: AudioProcessingState.buffering,
          ProcessingState.ready: AudioProcessingState.ready,
          ProcessingState.completed: AudioProcessingState.completed,
        }[_player.processingState]!,
        playing: playing,
        updatePosition: _player.position,
        bufferedPosition: _player.bufferedPosition,
        speed: _player.speed,
      ));
    });

    // Handle position updates
    _player.positionStream.listen((position) {
      playbackState.add(playbackState.value.copyWith(
        updatePosition: position,
      ));
    });

    // Handle duration updates
    _player.durationStream.listen((duration) {
      _durationSubject.add(duration ?? Duration.zero);
    });

    // Handle player state changes
    _player.playerStateStream.listen((playerState) {
      if (playerState.processingState == ProcessingState.completed) {
        stop();
      }
    });
  }

  // Load and play a song
  Future<void> playSong(Song song) async {
    try {
      // Update the current song
      _currentSongSubject.add(song);

      // Reset duration
      _durationSubject.add(Duration.zero);

      // Set the audio source
      await _player.stop();

      // Get duration first to avoid multiple URL fetches
      final duration = await _getDuration(song.previewUrl);

      // Update duration
      _durationSubject.add(duration);

      // Create media item for notification
      final mediaItemToAdd = MediaItem(
        id: song.id,
        title: song.title,
        artist: song.artist,
        artUri: Uri.parse(song.albumImage),
        duration: duration,
      );

      // Update the notification
      super.mediaItem.add(mediaItemToAdd);

      // Set the URL and play
      await _player.setUrl(song.previewUrl);
      await play();
    } catch (e) {
      if (kDebugMode) {
        print("Error playing song: $e");
      }
    }
  }

  // Get duration of the audio file
  Future<Duration> _getDuration(String url) async {
    try {
      final duration = await _player.setUrl(url);
      return duration ?? Duration.zero;
    } catch (e) {
      return Duration.zero;
    }
  }

  @override
  Future<void> play() => _player.play();

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> stop() async {
    await _player.stop();
    await super.stop();
  }

  @override
  Future<void> seek(Duration position) => _player.seek(position);

  @override
  Future<void> onTaskRemoved() async {
    await stop();
    await super.onTaskRemoved();
  }

  Future<void> cleanUp() async {
    await _player.dispose();
    await _currentSongSubject.close();
    await _durationSubject.close();
  }
}
