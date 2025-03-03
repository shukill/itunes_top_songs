import 'dart:async';
import 'package:audio_service/audio_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/services/audio_handler.dart';
import '../../../domain/entities/song.dart';
import 'audio_player_state.dart';

class AudioPlayerCubit extends Cubit<AudioPlayerState> {
  final AudioPlayerHandler _audioHandler;
  StreamSubscription<PlaybackState>? _playbackStateSubscription;
  StreamSubscription<Song?>? _currentSongSubscription;
  StreamSubscription<Duration>? _durationSubscription;

  AudioPlayerCubit(this._audioHandler) : super(const AudioPlayerState()) {
    // Listen to playback state changes
    _playbackStateSubscription =
        _audioHandler.playbackState.listen((playbackState) {
      final isPlaying = playbackState.playing;
      final position = playbackState.updatePosition;

      AudioPlayerStatus status;
      if (playbackState.processingState == AudioProcessingState.loading ||
          playbackState.processingState == AudioProcessingState.buffering) {
        status = AudioPlayerStatus.loading;
      } else if (isPlaying) {
        status = AudioPlayerStatus.playing;
      } else if (playbackState.processingState ==
          AudioProcessingState.completed) {
        status = AudioPlayerStatus.stopped;
      } else {
        status = AudioPlayerStatus.paused;
      }

      emit(state.copyWith(
        status: status,
        position: position,
      ));
    });

    // Listen to current song changes
    _currentSongSubscription = _audioHandler.currentSongStream.listen((song) {
      if (song != null) {
        emit(state.copyWith(currentSong: song));
      }
    });

    // Listen to duration changes
    _durationSubscription = _audioHandler.durationStream.listen((duration) {
      emit(state.copyWith(duration: duration));
    });
  }

  Future<void> playSong(Song song) async {
    if (state.currentSong?.id == song.id &&
        state.status == AudioPlayerStatus.paused) {
      return resume();
    }

    emit(state.copyWith(
      status: AudioPlayerStatus.loading,
      currentSong: song,
      position: Duration.zero,
      duration: Duration.zero,
    ));

    try {
      await _audioHandler.playSong(song);
    } catch (e) {
      emit(state.copyWith(
        status: AudioPlayerStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> pause() async {
    if (state.status == AudioPlayerStatus.playing) {
      await _audioHandler.pause();
    }
  }

  Future<void> resume() async {
    if (state.status == AudioPlayerStatus.paused) {
      await _audioHandler.play();
    }
  }

  Future<void> stop() async {
    await _audioHandler.stop();
  }

  @override
  Future<void> close() {
    _playbackStateSubscription?.cancel();
    _currentSongSubscription?.cancel();
    _durationSubscription?.cancel();
    return super.close();
  }
}
