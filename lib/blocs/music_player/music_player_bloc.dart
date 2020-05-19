import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_ui_avanzadas/models/artist.dart';
import 'music_player_events.dart';
import 'music_player_state.dart';

class MusicPlayerBloc extends Bloc<MusicPlayerEvent, MusicPlayerState> {
  final Artist artist;
  MusicPlayerBloc(this.artist);

  @override
  MusicPlayerState get initialState => MusicPlayerState.initialState();

  @override
  Stream<MusicPlayerState> mapEventToState(MusicPlayerEvent event) async* {
    if (event is NextTrackEvent) {
      final index = this.state.currentTrackIndex + 1;
      if (index < artist.tracks.length) {
        yield this.state.copyWith(currentTrackIndex: index);
      }
    } else if (event is PrevTrackEvent) {
      final index = this.state.currentTrackIndex - 1;
      if (index >= 0) {
        yield this.state.copyWith(currentTrackIndex: index);
      }
    }
  }

  static MusicPlayerBloc of(BuildContext context) {
    return BlocProvider.of<MusicPlayerBloc>(context);
  }
}
