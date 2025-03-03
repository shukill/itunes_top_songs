import '../../domain/entities/song.dart';
import '../datasources/song_local_data_source.dart';
import '../datasources/song_remote_data_source.dart';
import '../../domain/repositories/song_repository.dart';

class SongRepositoryImpl implements SongRepository {
  final SongRemoteDataSource remoteDataSource;
  final SongLocalDataSource localDataSource;
  bool _hasLoadedFromRemote = false;

  SongRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<List<Song>> getTopSongs() async {
    if (!_hasLoadedFromRemote) {
      try {
        final remoteSongs = await remoteDataSource.getTopSongs();
        await localDataSource.cacheSongs(remoteSongs);
        _hasLoadedFromRemote = true;
        return remoteSongs;
      } catch (e) {
        // If remote fetch fails, try to get from local
        return await localDataSource.getSongs();
      }
    } else {
      return await localDataSource.getSongs();
    }
  }
}
