import 'package:flutter_ui_avanzadas/blocs/music_player/music_player_state.dart';

abstract class MusicPlayerEvent {}

class NextTrackEvent extends MusicPlayerEvent {}

class PrevTrackEvent extends MusicPlayerEvent {}

