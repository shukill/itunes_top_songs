import 'package:equatable/equatable.dart';
import '../../../domain/entities/song.dart';

enum SongsStatus { initial, loading, loaded, error }

class SongsState extends Equatable {
  final List<Song> songs;
  final SongsStatus status;
  final String? errorMessage;

  const SongsState({
    this.songs = const [],
    this.status = SongsStatus.initial,
    this.errorMessage,
  });

  SongsState copyWith({
    List<Song>? songs,
    SongsStatus? status,
    String? errorMessage,
  }) {
    return SongsState(
      songs: songs ?? this.songs,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [songs, status, errorMessage];
}
