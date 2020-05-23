import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ui_avanzadas/blocs/music_player/bloc.dart';

class MusicControls extends StatelessWidget {
  const MusicControls({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MusicPlayerBloc bloc = MusicPlayerBloc.of(context);
    return BlocBuilder<MusicPlayerBloc, MusicPlayerState>(
      builder: (_, state) {
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
              valueListenable: bloc.player.status,
              builder: (BuildContext context, MusicPlayerStatus status,
                  Widget child) {
                Widget icon;

                if (bloc.player.loading) {
                  return Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: CupertinoActivityIndicator(
                      radius: 15,
                    ),
                  );
                } else if (bloc.player.error) {
                  return Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Icon(
                      Icons.error,
                      color: Colors.red,
                      size: 60,
                    ),
                  );
                } else {
                  icon = Icon(
                    bloc.player.playing ? Icons.pause : Icons.play_arrow,
                    color: Colors.black,
                    size: 60,
                  );
                }

                return CupertinoButton(
                  padding: EdgeInsets.all(5),
                  color: Color(0xffeeeeee),
                  borderRadius: BorderRadius.circular(60),
                  child: icon,
                  onPressed: () {
                    if (bloc.player.playing) {
                      bloc.player.pause();
                    } else {
                      bloc.player.resume();
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
      },
    );
  }
}
