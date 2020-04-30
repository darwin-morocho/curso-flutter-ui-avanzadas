import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ui_avanzadas/api/deezer_api.dart';
import 'package:flutter_ui_avanzadas/models/artist.dart';
import 'home_events.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  @override
  HomeState get initialState => HomeState();

  HomeBloc() {
    add(CheckDbEvent());
  }

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    if (event is CheckDbEvent) {
      await Future.delayed(Duration(seconds: 2));
      add(LoadArtistsEvent());
    } else if (event is LoadArtistsEvent) {
      yield* _loadArtists();
    } else if (event is DownloadPlayListsEvent) {
    } else if (event is OnSelectedArtistEvent) {
      final artists = [...this.state.artists];
      final artist = artists[event.index];
      artists[event.index] = artist.onSelected(!artist.selected);
      yield this.state.copyWith(artists: artists);
    }
  }

  Stream<HomeState> _loadArtists() async* {
    yield this.state.copyWith(status: HomeStatus.loadingArtists);
    final List<Artist> artists = await DeezerAPI.instance.artists;
    if (artists != null) {
      yield this.state.copyWith(
            status: HomeStatus.selectArtists,
            artists: artists,
          );
    } else {
      yield this.state.copyWith(status: HomeStatus.error);
    }
  }

  factory HomeBloc.of(BuildContext context) =>
      BlocProvider.of<HomeBloc>(context);
}
