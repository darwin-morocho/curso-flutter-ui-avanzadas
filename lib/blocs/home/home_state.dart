import 'package:equatable/equatable.dart';
import 'package:flutter_ui_avanzadas/models/artist.dart';
import 'package:meta/meta.dart' show required;

enum HomeStatus { checking, loading, selecting, downloading, ready, error }

class HomeState extends Equatable {
  final HomeStatus status;
  final List<Artist> artists;

  HomeState({@required this.status, @required this.artists});

  static HomeState get initialState => HomeState(
        status: HomeStatus.checking,
        artists: const [],
      );

  HomeState copyWith({HomeStatus status, List<Artist> artists}) {
    return HomeState(
      status: status ?? this.status,
      artists: artists ?? this.artists,
    );
  }

  @override
  List<Object> get props => [status, artists];
}
