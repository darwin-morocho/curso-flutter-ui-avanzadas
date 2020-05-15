import 'package:flutter_ui_avanzadas/models/track.dart';
import 'package:meta/meta.dart' show required;

class Artist {
  final int id;
  final String name;
  final String picture;
  final String tracklist;
  final bool selected;
  final List<Track> tracks;

  Artist({
    @required this.id,
    @required this.name,
    @required this.picture,
    @required this.tracklist,
    this.selected = false,
    this.tracks = const [],
  });

  factory Artist.fromJson(Map<String, dynamic> json) {
    List<Track> tracks = [];
    if (json['tracks'] != null) {
      tracks = (json['tracks'] as List)
          .map<Track>((e) => Track.fromJson(e))
          .toList();
    }

    return Artist(
      id: json['id'],
      name: json['name'],
      picture: json['picture_big'],
      tracklist: json['tracklist'],
      tracks: tracks,
    );
  }

  Artist onSelected() {
    return Artist(
      id: this.id,
      name: this.name,
      picture: this.picture,
      tracklist: this.tracklist,
      selected: !this.selected,
      tracks: this.tracks,
    );
  }

  Artist addTracks(List<Track> tracks) {
    return Artist(
      id: this.id,
      name: this.name,
      picture: this.picture,
      tracklist: this.tracklist,
      selected: this.selected,
      tracks: tracks,
    );
  }

  Map<String, dynamic> toJson() {
    final List<Map<String, dynamic>> tracks =
        this.tracks.map((e) => e.toJson()).toList();
    return {
      "id": this.id,
      "name": this.name,
      "picture_big": this.picture,
      "tracklist": this.tracklist,
      "tracks": tracks,
    };
  }
}
