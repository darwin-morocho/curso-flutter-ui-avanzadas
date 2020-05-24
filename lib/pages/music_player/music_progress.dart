import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ui_avanzadas/blocs/music_player/music_player_bloc.dart';
import 'package:flutter_ui_avanzadas/libs/music_Player.dart';

String formatTime(Duration duration) {
  if (duration == null) return "--:--";
  String twoDigits(int n) {
    if (n >= 10) return "$n";
    return "0$n";
  }

  String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
  return "$twoDigitMinutes:$twoDigitSeconds";
}

class MusicProgress extends StatefulWidget {
  @override
  _MusicProgressState createState() => _MusicProgressState();
}

class _MusicProgressState extends State<MusicProgress> with AfterLayoutMixin {
  ValueNotifier<double> _position = ValueNotifier(0);
  MusicPlayerBloc _bloc;
  bool _dragging = false;

  @override
  void afterFirstLayout(BuildContext context) {
    _bloc = MusicPlayerBloc.of(context);
    _bloc.player.position.addListener(() {
      if (!_dragging) {
        _position.value = _bloc.player.position.value.inSeconds.toDouble();
      }
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (_bloc == null) return Container();

    final MusicPlayer player = _bloc.player;
    return ValueListenableBuilder(
      valueListenable: player.status,
      builder: (BuildContext context, MusicPlayerStatus status, Widget child) {
        return Container(
          padding: EdgeInsets.all(15),
          child: Row(
            children: <Widget>[
              ValueListenableBuilder(
                valueListenable: player.position,
                builder:
                    (BuildContext context, Duration position, Widget child) {
                  return Text(
                    formatTime(position),
                  );
                },
              ),
              Expanded(
                child: ValueListenableBuilder(
                  valueListenable: this._position,
                  builder:
                      (BuildContext context, double position, Widget child) {
                    double value;
                    if (player.duration == null) {
                      value = 0;
                    } else {
                      value = position;
                    }

                    final max = player.duration != null
                        ? player.duration.inSeconds.toDouble()
                        : 100.0;

                    return AbsorbPointer(
                      absorbing: player.loading || player.error,
                      child: Slider(
                        value: value,
                        label: formatTime(Duration(seconds: value.toInt())),
                        divisions: 100,
                        min: 0,
                        max: max,
                        onChanged: (v) {
                          this._position.value = v;
                        },
                        onChangeStart: (v) {
                          this._dragging = true;
                        },
                        onChangeEnd: (v) {
                          this._dragging = false;
                          player.seekTo(Duration(seconds: v.toInt()));
                        },
                      ),
                    );
                  },
                ),
              ),
              Text(
                formatTime(player.duration),
              ),
            ],
          ),
        );
      },
    );
  }
}
