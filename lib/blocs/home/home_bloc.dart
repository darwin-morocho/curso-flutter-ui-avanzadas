import 'package:bloc/bloc.dart';
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
      await Future.delayed(Duration(seconds: 2));
      yield this.state.copyWith(status: HomeStatus.loading);
    }
  }
}
