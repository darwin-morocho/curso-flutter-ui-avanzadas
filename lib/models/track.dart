
import 'package:meta/meta.dart' show required;

class Track {
  final int id;
  final String title;
  final String preview;
  final int duration;
  final Album album;
  final int artistId;
  final int rank;

  Track(
      {@required this.id,
      @required this.title,
      @required this.preview,
      @required this.duration,
      @required this.album,
      @required this.artistId,
      @required this.rank});

  factory Track.fromJson(int artistId, Map<String, dynamic> json) {
    return Track(
        id: json['id'],
        title: json['title'],
        preview: json['preview'],
        duration: json['duration'],
        album: Album.fromJson(Map.from(json['album'])),
        artistId: artistId,
        rank: json['rank']);
  }

  Map<String, dynamic> toJson() {
    return {
      "id": this.id,
      "title": this.title,
      "preview": this.preview,
      "duration": this.duration,
      "rank": this.rank,
      "album": this.album.toJson()
    };
  }
}

class Album {
  final int id;
  final String title, cover;

  Album({
    @required this.id,
    @required this.title,
    @required this.cover,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      id: json['id'],
      title: json['title'],
      cover: json['cover_xl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": this.id,
      "title": this.title,
      "cover": this.cover,
    };
  }
}
