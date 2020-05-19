import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart' show required;

class MusicPlayerState extends Equatable {
  final int currentTrackIndex;

  MusicPlayerState({
    @required this.currentTrackIndex,
  });

  MusicPlayerState copyWith({int currentTrackIndex}) {
    return MusicPlayerState(
      currentTrackIndex: currentTrackIndex ?? this.currentTrackIndex,
    );
  }

  static MusicPlayerState initialState() {
    return MusicPlayerState(currentTrackIndex: 0);
  }

  @override
  List<Object> get props => [
        currentTrackIndex,
      ];
}
