import 'package:bloc/bloc.dart';
import 'package:flutter_ui_avanzadas/api/deezer_api.dart';
import 'package:flutter_ui_avanzadas/models/artist.dart';
import 'home_events.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() {
    add(CheckDbEvent());
  }

  @override
  HomeState get initialState => HomeState.initialState;

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    if (event is CheckDbEvent) {
      yield* this._mapCheckDb(event);
    }
  }

  Stream<HomeState> _mapCheckDb(CheckDbEvent event) async* {
    await Future.delayed(Duration(seconds: 2));
    yield this.state.copyWith(status: HomeStatus.loading);

    final List<Artist> artists = await DeezerAPI.instance.getArtist();

    if (artists != null) {
      print("artists ${artists.length}");
      yield this.state.copyWith(
            status: HomeStatus.selecting,
            artists: artists,
          );
    } else {
      yield this.state.copyWith(status: HomeStatus.error);
    }
  }
}
