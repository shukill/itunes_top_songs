import 'package:equatable/equatable.dart';

class Song extends Equatable {
  final String id;
  final String title;
  final String artist;
  final String albumImage;
  final String previewUrl;

  const Song({
    required this.id,
    required this.title,
    required this.artist,
    required this.albumImage,
    required this.previewUrl,
  });

  @override
  List<Object?> get props => [id, title, artist, albumImage, previewUrl];
}
