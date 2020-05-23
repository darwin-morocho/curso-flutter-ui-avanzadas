import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ui_avanzadas/blocs/music_player/bloc.dart';

import 'package:flutter_ui_avanzadas/models/artist.dart';
import 'package:flutter_ui_avanzadas/models/track.dart';
import 'music_player_events.dart';
import 'music_player_state.dart';

enum MusicPlayerStatus {
  loading,
  error,
  playing,
  paused,
}

class MusicPlayer {
  MusicPlayer({@required this.onCompleted}) {
    _init();
  }

  final VoidCallback onCompleted;

  AudioPlayer _audioPlayer = AudioPlayer();
  ValueNotifier<MusicPlayerStatus> status =
      ValueNotifier(MusicPlayerStatus.loading);

  ValueNotifier<Duration> _position = ValueNotifier(Duration.zero);

  Duration _duration;
  Duration get duration => _duration;
  ValueNotifier<Duration> get position => _position;

  bool get loading {
    return status.value == MusicPlayerStatus.loading;
  }

  bool get playing {
    return status.value == MusicPlayerStatus.playing;
  }

  bool get paused {
    return status.value == MusicPlayerStatus.paused;
  }

  bool get error {
    return status.value == MusicPlayerStatus.error;
  }

  Future<void> play(String url) async {
    try {
      _duration = null;
      _position.value = Duration.zero;
      status.value = MusicPlayerStatus.loading;
      await _audioPlayer.stop();

      final int result = await _audioPlayer.setUrl(url);

      print("result $result");
      if (result == 1) {
        await _audioPlayer.resume();
      } else {
        status.value = MusicPlayerStatus.error;
      }
    } on PlatformException catch (e) {
      print("error code ${e.code}");
      print("error message ${e.message}");
      print("error details ${e.details}");
      status.value = MusicPlayerStatus.error;
    }
  }

  Future<void> seekTo(Duration position) async {
    _position.value = position;
    await _audioPlayer.seek(position);
  }

  Future<void> pause() async {
    await _audioPlayer.pause();
    status.value = MusicPlayerStatus.paused;
  }

  Future<void> resume() async {
    await _audioPlayer.resume();
    status.value = MusicPlayerStatus.playing;
  }

  Future<void> dispose() async {
    await _audioPlayer.stop();
    await _audioPlayer.dispose();
  }

  void _init() {
    _audioPlayer.onPlayerCompletion.listen((event) {
      onCompleted();
    });

    _audioPlayer.onAudioPositionChanged.listen((position) {
      _position.value = position;
    });
    _audioPlayer.onDurationChanged.listen((duration) {
      if (_duration == null || _duration.compareTo(duration) != 0) {
        print("duration: $duration");
        _duration = duration;
        status.value = MusicPlayerStatus.playing;
      }
    });
  }
}

class MusicPlayerBloc extends Bloc<MusicPlayerEvent, MusicPlayerState> {
  final Artist artist;

  MusicPlayer _player;
  MusicPlayer get player => _player;

  MusicPlayerBloc(this.artist) {
    _player = MusicPlayer(onCompleted: this._onCompleted);
    _play();
  }

  @override
  Future<void> close() async {
    _player.dispose();
    return super.close();
  }

  _onCompleted() {
    add(NextTrackEvent());
  }

  Future<void> _play() async {
    final int index = this.state.currentTrackIndex;
    final Track track = artist.tracks[index];
    _player.play(track.preview);
  }

  @override
  MusicPlayerState get initialState => MusicPlayerState.initialState();

  @override
  Stream<MusicPlayerState> mapEventToState(MusicPlayerEvent event) async* {
    if (event is NextTrackEvent) {
      final index = this.state.currentTrackIndex + 1;
      if (index < artist.tracks.length) {
        yield this.state.copyWith(currentTrackIndex: index);
        _play();
      }
    } else if (event is PrevTrackEvent) {
      final index = this.state.currentTrackIndex - 1;
      if (index >= 0) {
        yield this.state.copyWith(currentTrackIndex: index);
        _play();
      }
    }
  }

  static MusicPlayerBloc of(BuildContext context) {
    return BlocProvider.of<MusicPlayerBloc>(context);
  }
}
