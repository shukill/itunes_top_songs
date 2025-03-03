import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/song_model.dart';

abstract class SongLocalDataSource {
  Future<List<SongModel>> getSongs();
  Future<void> cacheSongs(List<SongModel> songs);
  Future<void> clearSongs();
}

class SongLocalDataSourceImpl implements SongLocalDataSource {
  final Database database;

  SongLocalDataSourceImpl({required this.database});

  static Future<Database> openDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'songs_database.db');

    return await sqflite.openDatabase(
      path,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE songs(id TEXT PRIMARY KEY, title TEXT, artist TEXT, albumImage TEXT, previewUrl TEXT)',
        );
      },
      version: 1,
    );
  }

  @override
  Future<List<SongModel>> getSongs() async {
    final List<Map<String, dynamic>> maps = await database.query('songs');
    return List.generate(maps.length, (i) {
      return SongModel.fromMap(maps[i]);
    });
  }

  @override
  Future<void> cacheSongs(List<SongModel> songs) async {
    await clearSongs();

    for (var song in songs) {
      await database.insert(
        'songs',
        song.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  @override
  Future<void> clearSongs() async {
    await database.delete('songs');
  }
}
