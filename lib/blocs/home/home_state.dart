import 'package:equatable/equatable.dart';
import 'package:flutter_ui_avanzadas/models/artist.dart';

enum HomeStatus {
  checkingDb,
  error,
  loadingArtists,
  selectArtists,
  downloading,
  myArtists
}

class HomeState extends Equatable {
  final HomeStatus status;
  final List<Artist> artists;
  final String searchText;

  HomeState({
    this.status = HomeStatus.checkingDb,
    this.artists = const [],
    this.searchText = '',
  });

  HomeState copyWith({
    HomeStatus status,
    List<Artist> artists,
    String searchText,
  }) {
    return HomeState(
      status: status ?? this.status,
      artists: artists ?? this.artists,
      searchText: searchText ?? this.searchText,
    );
  }

  @override
  List<Object> get props => [status, artists, searchText];
}
