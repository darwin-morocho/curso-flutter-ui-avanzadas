import 'package:meta/meta.dart' show required;

class Artist {
  final int id;
  final String name;
  final String picture;
  final String tracklist;

  Artist({
    @required this.id,
    @required this.name,
    @required this.picture,
    @required this.tracklist,
  });

  factory Artist.fromJson(Map<String, dynamic> json) {
    return Artist(
      id: json['id'],
      name: json['name'],
      picture: json['picture_big'],
      tracklist: json['tracklist'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": this.id,
      "name": this.name,
      "picture_big": this.picture,
      "tracklist": this.tracklist,
    };
  }
}
