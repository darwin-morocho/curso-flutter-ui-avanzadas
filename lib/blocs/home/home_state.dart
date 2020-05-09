import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart' show required;

import 'bloc.dart';

enum HomeStatus {
  checking,
  loading,
  selecting,
  downloading,
  ready,
}

class HomeState extends Equatable {
  final HomeStatus status;

  HomeState({@required this.status});

  static HomeState get initialState => HomeState(
        status: HomeStatus.checking,
      );

  HomeState copyWith({HomeStatus status}) {
    return HomeState(
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [status];
}
