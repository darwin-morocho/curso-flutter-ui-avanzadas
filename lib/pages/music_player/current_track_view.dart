import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ui_avanzadas/blocs/music_player/bloc.dart';
import 'package:flutter_ui_avanzadas/models/track.dart';

class CurrentTrackView extends StatelessWidget {
  const CurrentTrackView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MusicPlayerBloc bloc = MusicPlayerBloc.of(context);
    return Container(
      child: BlocBuilder<MusicPlayerBloc, MusicPlayerState>(
        builder: (_, state) {
          final Track currentTrack =
              bloc.artist.tracks[state.currentTrackIndex];
          return Column(
            children: <Widget>[
              AspectRatio(
                aspectRatio: 16 / 14,
                child: ClipPath(
                  clipper: AlbumClipper(),
                  child: Container(
                    child: Stack(
                      children: <Widget>[
                        Positioned.fill(
                          child: CachedNetworkImage(
                            imageUrl: currentTrack.album.cover,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned.fill(
                          child: Container(
                            color: Colors.black.withOpacity(0.4),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Text(
                currentTrack.album.title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w300,
                ),
              ),
              Text(
                currentTrack.title,
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5),
              Text(
                "${state.currentTrackIndex + 1} / ${bloc.artist.tracks.length}",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w100,
                ),
              ),
              SizedBox(height: 15),
            ],
          );
        },
      ),
    );
  }
}

class AlbumClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height);
    path.arcToPoint(
      Offset(size.width, size.height),
      radius: Radius.circular(size.width * 1.5),
      clockwise: true,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return true;
  }
}
