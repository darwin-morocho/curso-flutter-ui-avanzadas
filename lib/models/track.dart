import 'package:meta/meta.dart' show required;

class Track {
  final int id, duration, rank;
  final String title, preview;
  final Album album;

  Track({
    @required this.id,
    @required this.duration,
    @required this.rank,
    @required this.title,
    @required this.preview,
    @required this.album,
  });

  factory Track.fromJson(Map<String, dynamic> json) {
    return Track(
      id: json['id'],
      duration: json['duration'],
      rank: json['rank'],
      title: json['title'],
      preview: json['preview'],
      album: Album.fromJson(json['album']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": this.id,
      "duration": this.duration,
      "rank": this.rank,
      "title": this.title,
      "preview": this.preview,
      "album": this.album.toJson(),
    };
  }
}

class Album {
  final int id;
  final String title, cover, tracklist;

  Album({
    @required this.id,
    @required this.title,
    @required this.cover,
    @required this.tracklist,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      id: json['id'],
      title: json['title'],
      cover: json['cover_big'],
      tracklist: json['tracklist'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": this.id,
      "title": this.title,
      "cover_big": this.cover,
      "tracklist": this.tracklist,
    };
  }
}
