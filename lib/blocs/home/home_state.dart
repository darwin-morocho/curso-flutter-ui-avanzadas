import 'package:equatable/equatable.dart';
import 'package:flutter_ui_avanzadas/models/artist.dart';
import 'package:meta/meta.dart' show required;

enum HomeStatus { checking, loading, selecting, downloading, ready, error }

class HomeState extends Equatable {
  final HomeStatus status;
  final List<Artist> artists;
  final String searchText;

  HomeState({
    @required this.status,
    @required this.artists,
    @required this.searchText,
  });

  static HomeState get initialState => HomeState(
        status: HomeStatus.checking,
        artists: const [],
        searchText: '',
      );

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
  List<Object> get props => [
        status,
        artists,
        searchText,
      ];
}
