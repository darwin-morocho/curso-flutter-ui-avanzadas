import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ui_avanzadas/blocs/music_player/bloc.dart';
import 'package:flutter_ui_avanzadas/libs/music_player.dart';

class MusicControls extends StatelessWidget {
  const MusicControls({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MusicPlayerBloc bloc = MusicPlayerBloc.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CupertinoButton(
          padding: EdgeInsets.all(5),
          color: Color(0xffeeeeee),
          borderRadius: BorderRadius.circular(60),
          child: Icon(
            Icons.skip_previous,
            size: 40,
            color: Colors.black,
          ),
          onPressed: () {
            bloc.add(PrevTrackEvent());
          },
        ),
        SizedBox(width: 25),
        ValueListenableBuilder(
          valueListenable: bloc.musicPlayer.status,
          builder:
              (BuildContext context, MusicPlayerStatus status, Widget child) {
            if (status==MusicPlayerStatus.loading) {
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: CupertinoActivityIndicator(
                  radius: 15,
                ),
              );
            } else if (bloc.musicPlayer.error) {
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: Icon(
                  Icons.error,
                  size: 50,
                  color: Colors.redAccent,
                ),
              );
            }

            return CupertinoButton(
              padding: EdgeInsets.all(5),
              color: Color(0xffeeeeee),
              borderRadius: BorderRadius.circular(60),
              child: Icon(
                bloc.musicPlayer.playing ? Icons.pause : Icons.play_arrow,
                size: 60,
                color: Colors.black,
              ),
              onPressed: () {
                if (bloc.musicPlayer.playing) {
                  bloc.musicPlayer.pause();
                } else {
                  bloc.musicPlayer.resume();
                }
              },
            );
          },
        ),
        SizedBox(width: 25),
        CupertinoButton(
          padding: EdgeInsets.all(5),
          color: Color(0xffeeeeee),
          borderRadius: BorderRadius.circular(60),
          child: Icon(
            Icons.skip_next,
            size: 40,
            color: Colors.black,
          ),
          onPressed: () {
            bloc.add(NextTrackEvent());
          },
        )
      ],
    );
  }
}
