import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ui_avanzadas/blocs/music_player/music_player_bloc.dart';
import 'package:flutter_ui_avanzadas/libs/music_player.dart';

String formatTime(Duration time) {
  if (time == null) return "--:--";

  String twoDigits(int v) {
    if (v >= 10) return v.toString();
    return "0$v";
  }

  final minutes = time.inMinutes.remainder(60);
  final seconds = time.inSeconds.remainder(60);

  return "${twoDigits(minutes)}:${twoDigits(seconds)}";
}

class MusicPlayerProgress extends StatefulWidget {
  @override
  _MusicPlayerProgressState createState() => _MusicPlayerProgressState();
}

class _MusicPlayerProgressState extends State<MusicPlayerProgress>
    with AfterLayoutMixin {
  ValueNotifier<double> _sliderValue = ValueNotifier(0);
  MusicPlayerBloc _bloc;

  bool _dragging = false;

  @override
  void afterFirstLayout(BuildContext context) {
    _bloc = MusicPlayerBloc.of(context);
    _bloc.musicPlayer.position.addListener(() {
      if (_dragging == false) {
        _sliderValue.value =
            _bloc.musicPlayer.position.value.inSeconds.toDouble();
      }
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (_bloc == null) return Container();

    final musicPlayer = _bloc.musicPlayer;
    return Container(
      padding: EdgeInsets.all(15),
      child: ValueListenableBuilder(
        valueListenable: musicPlayer.status,
        builder: (_, MusicPlayerStatus status, __) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              ValueListenableBuilder(
                valueListenable: musicPlayer.position,
                builder: (_, Duration position, __) {
                  return Text(
                    formatTime(position),
                  );
                },
              ),
              Expanded(
                child: ValueListenableBuilder(
                  valueListenable: _sliderValue,
                  builder: (BuildContext context, double value, Widget child) {
                    double max = 100;
                    if (musicPlayer.duration != null) {
                      max = musicPlayer.duration.inSeconds.toDouble();
                    }

                    return AbsorbPointer(
                      absorbing: musicPlayer.loading,
                      child: Slider(
                        value: value,
                        min: 0,
                        max: max,
                        onChangeStart: (_) {
                          _dragging = true;
                        },
                        label:
                            "${formatTime(Duration(seconds: value.toInt()))}",
                        divisions: 100,
                        onChangeEnd: (_) {
                          _dragging = false;
                          musicPlayer.seekTo(
                            Duration(seconds: value.toInt()),
                          );
                        },
                        onChanged: (double v) {
                          _sliderValue.value = v;
                        },
                      ),
                    );
                  },
                ),
              ),
              Text(formatTime(musicPlayer.duration))
            ],
          );
        },
      ),
    );
  }
}
