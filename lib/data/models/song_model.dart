import '../../domain/entities/song.dart';

class SongModel extends Song {
  const SongModel({
    required super.id,
    required super.title,
    required super.artist,
    required super.albumImage,
    required super.previewUrl,
  });

  factory SongModel.fromJson(Map<String, dynamic> json) {
    // Extract ID safely
    String id = '';
    if (json['id'] is Map) {
      final idMap = json['id'] as Map<String, dynamic>;
      if (idMap['attributes'] is Map) {
        id = idMap['attributes']['im:id']?.toString() ?? '';
      }
    }

    // Extract title safely
    String title = '';
    if (json['im:name'] is Map) {
      title = json['im:name']['label']?.toString() ?? '';
    }

    // Extract artist safely
    String artist = '';
    if (json['im:artist'] is Map) {
      artist = json['im:artist']['label']?.toString() ?? '';
    }

    // Find the highest resolution image
    String albumImage = '';
    if (json['im:image'] != null &&
        json['im:image'] is List &&
        (json['im:image'] as List).isNotEmpty) {
      // Try to get the image with height 170, or fall back to the last one
      final images = json['im:image'] as List;
      try {
        final highResImage = images.lastWhere(
          (image) =>
              image is Map &&
              image['attributes'] is Map &&
              image['attributes']['height'] == '170',
          orElse: () => images.last,
        );
        if (highResImage is Map) {
          albumImage = highResImage['label']?.toString() ?? '';
        }
      } catch (e) {
        // Fallback if any error occurs during image extraction
        albumImage = '';
      }
    }

    // Extract the preview URL from the link array
    String previewUrl = '';
    if (json['link'] != null && json['link'] is List) {
      final links = json['link'] as List;
      // Find the link with rel="enclosure" which contains the preview
      final previewLink = links.firstWhere(
        (link) => link['attributes']?['rel'] == 'enclosure',
        orElse: () => {
          'attributes': {'href': ''}
        },
      );
      previewUrl = previewLink['attributes']?['href'] ?? '';
    }

    return SongModel(
      id: id,
      title: title,
      artist: artist,
      albumImage: albumImage,
      previewUrl: previewUrl,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'artist': artist,
      'albumImage': albumImage,
      'previewUrl': previewUrl,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'artist': artist,
      'albumImage': albumImage,
      'previewUrl': previewUrl,
    };
  }

  factory SongModel.fromMap(Map<String, dynamic> map) {
    return SongModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      artist: map['artist'] ?? '',
      albumImage: map['albumImage'] ?? '',
      previewUrl: map['previewUrl'] ?? '',
    );
  }
}
