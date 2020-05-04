import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ui_avanzadas/api/deezer_api.dart';

import 'package:flutter_ui_avanzadas/models/artist.dart';
import 'package:flutter_ui_avanzadas/models/track.dart';
import 'package:flutter_ui_avanzadas/sembast/db.dart';
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
      final artists = await ArtistsStore.instance.getAll();
      if (artists.length >= 5) {
        yield this.state.copyWith(
              artists: artists,
              status: HomeStatus.myArtists,
            );
      } else {
        add(LoadArtistsEvent());
      }
    } else if (event is LoadArtistsEvent) {
      yield* _loadArtists();
    } else if (event is DownloadPlayListsEvent) {
      yield* _downLoadPlayLists();
    } else if (event is OnSelectedArtistEvent) {
      final artists = [...this.state.artists];
      final int index = artists.indexWhere((item) => item.id == event.id);
      if (index != -1) {
        final artist = artists[index];
        artists[index] = artist.onSelected(!artist.selected);
        yield this.state.copyWith(artists: artists);
      }
    } else if (event is OnSearchChangeEvent) {
      yield this.state.copyWith(searchText: event.text);
    }
  }

  Stream<HomeState> _downLoadPlayLists() async* {
    yield this.state.copyWith(status: HomeStatus.downloading);
    final artists = this.state.artists.where((item) => item.selected).toList();
    for (final artist in artists) {
      final List<Track> tracks = await DeezerAPI.instance.getTracks(artist.id);
      artist.tracks = tracks;
    }
    await ArtistsStore.instance.addAll(artists);
    yield this.state.copyWith(
          status: HomeStatus.myArtists,
          artists: artists.toList(),
        );
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
