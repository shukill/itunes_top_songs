import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_top_songs.dart';
import 'songs_state.dart';

class SongsCubit extends Cubit<SongsState> {
  final GetTopSongs getTopSongs;

  SongsCubit({required this.getTopSongs}) : super(const SongsState());

  Future<void> loadSongs() async {
    emit(state.copyWith(status: SongsStatus.loading));

    try {
      final songs = await getTopSongs();
      emit(state.copyWith(
        songs: songs,
        status: SongsStatus.loaded,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: SongsStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }
}
