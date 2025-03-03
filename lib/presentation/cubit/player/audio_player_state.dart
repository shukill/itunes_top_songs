import 'package:equatable/equatable.dart';
import '../../../domain/entities/song.dart';

enum AudioPlayerStatus { initial, loading, playing, paused, stopped, error }

class AudioPlayerState extends Equatable {
  final Song? currentSong;
  final AudioPlayerStatus status;
  final String? errorMessage;
  final Duration position;
  final Duration duration;

  const AudioPlayerState({
    this.currentSong,
    this.status = AudioPlayerStatus.initial,
    this.errorMessage,
    this.position = Duration.zero,
    this.duration = Duration.zero,
  });

  AudioPlayerState copyWith({
    Song? currentSong,
    AudioPlayerStatus? status,
    String? errorMessage,
    Duration? position,
    Duration? duration,
  }) {
    return AudioPlayerState(
      currentSong: currentSong ?? this.currentSong,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      position: position ?? this.position,
      duration: duration ?? this.duration,
    );
  }

  @override
  List<Object?> get props =>
      [currentSong, status, errorMessage, position, duration];
}
