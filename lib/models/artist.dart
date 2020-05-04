import 'package:equatable/equatable.dart';
import 'package:flutter_ui_avanzadas/models/track.dart';

import 'package:meta/meta.dart' show required;

class Artist with EquatableMixin {
  final int id;

  final String name;

  final String picture;

  final String tracklist;

  final bool selected;

  List<Track> tracks;

  Artist({
    @required this.id,
    @required this.name,
    @required this.picture,
    this.tracklist,
    this.selected = false,
    this.tracks = const [],
  });

  factory Artist.fromJson(Map<String, dynamic> json) {
    final int artistId = json['id'];
    final List<Track> tracks = [];
    if (json['tracks'] != null) {
      print(json['tracks'].runtimeType);
      final tmp = (json['tracks'] as List).map((json) {
        print(json.runtimeType);
        final track = Track.fromJson(artistId, json);
        print(track.artistId);
        return track;
       
      });
      tracks.addAll(tmp);
    }
    return Artist(
      id: artistId,
      name: json['name'],
      picture: json['picture_big'],
      tracklist: json['tracklist'],
      tracks: tracks,
    );
  }

  Map<String, dynamic> toJson() {
    final List tracks = this.tracks.map((track) => track.toJson()).toList();
    return {
      "id": this.id,
      "name": this.name,
      "picture_big": this.picture,
      "tracklist": this.tracklist,
      "tracks": tracks
    };
  }

  Artist onSelected(bool selected) {
    return Artist(
      id: this.id,
      name: this.name,
      picture: this.picture,
      tracklist: this.tracklist,
      selected: selected,
    );
  }

  @override
  List<Object> get props => [id, name, picture, tracklist, selected];
}
