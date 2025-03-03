import 'dart:convert';

import 'package:dio/dio.dart';
import '../models/song_model.dart';

abstract class SongRemoteDataSource {
  Future<List<SongModel>> getTopSongs();
}

class SongRemoteDataSourceImpl implements SongRemoteDataSource {
  final Dio dio;

  SongRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<SongModel>> getTopSongs() async {
    try {
      final response = await dio.get(
        'http://ax.itunes.apple.com/WebObjects/MZStoreServices.woa/ws/RSS/topsongs/limit=20/json',
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.data) as Map<String, dynamic>;
        final entries = data['feed']['entry'] as List;
        return entries.map((entry) => SongModel.fromJson(entry)).toList();
      } else {
        throw Exception('Failed to load songs');
      }
    } catch (e) {
      throw Exception('Failed to load songs: $e');
    }
  }
}
