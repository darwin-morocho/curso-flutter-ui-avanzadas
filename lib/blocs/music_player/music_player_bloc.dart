import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sound/flutter_sound.dart' as FlutterSound;
import 'package:flutter_ui_avanzadas/blocs/music_player/bloc.dart';
import 'package:flutter_ui_avanzadas/libs/music_player.dart';
import 'package:flutter_ui_avanzadas/models/artist.dart';
import 'package:flutter_ui_avanzadas/models/track.dart';
import 'music_player_events.dart';
import 'music_player_state.dart';

class MusicPlayerBloc extends Bloc<MusicPlayerEvent, MusicPlayerState> {
  final Artist artist;

  MusicPlayer _player;
  MusicPlayer get player => _player;

  MusicPlayerBloc(this.artist) {
    _player = MusicPlayer(onNext: this._onNext,onPrev: this._onPrev);
    _play();
  }

  @override
  Future<void> close() async {
   await  _player.dispose();
    return super.close();
  }

 

  _onNext() {
    add(NextTrackEvent());
  }

  _onPrev() {
    add(PrevTrackEvent());
  }

  Future<void> _play() async {
    final int index = this.state.currentTrackIndex;
    final Track track = artist.tracks[index];
    final soundTrack = FlutterSound.Track(
      trackTitle: track.title,
      trackAuthor: artist.name,
      trackPath: track.preview,
    );
    _player.play(soundTrack);
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
