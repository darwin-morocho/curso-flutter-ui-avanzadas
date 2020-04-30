import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart' show required;

class Artist extends Equatable {
  final int id;
  final String name, picture, tracklist;
  final bool selected;

  Artist({
    @required this.id,
    @required this.name,
    @required this.picture,
    this.tracklist,
    this.selected = false,
  });

  factory Artist.fromJson(Map<String, dynamic> json) {
    return Artist(
      id: json['id'],
      name: json['name'],
      picture: json['picture_big'],
      tracklist: json['tracklist'],
    );
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
