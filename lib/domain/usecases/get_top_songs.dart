import '../entities/song.dart';
import '../repositories/song_repository.dart';

class GetTopSongs {
  final SongRepository repository;

  GetTopSongs(this.repository);

  Future<List<Song>> call() async {
    return await repository.getTopSongs();
  }
}
