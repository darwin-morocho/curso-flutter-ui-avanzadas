import 'package:equatable/equatable.dart';
import 'package:flutter_ui_avanzadas/models/artist.dart';

enum HomeStatus { checkingDb, error, loadingArtists, selectArtists }

class HomeState extends Equatable {
  final HomeStatus status;
  final List<Artist> artists;

  HomeState({
    this.status = HomeStatus.checkingDb,
    this.artists = const [],
  });

  HomeState copyWith({HomeStatus status, List<Artist> artists}) {
    return HomeState(
      status: status ?? this.status,
      artists: artists ?? this.artists,
    );
  }

  @override
  List<Object> get props => [status, artists];
}
