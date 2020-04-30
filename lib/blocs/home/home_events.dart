abstract class HomeEvent {}

class CheckDbEvent extends HomeEvent {}

class LoadArtistsEvent extends HomeEvent{}

class DownloadPlayListsEvent extends HomeEvent {}


class OnSelectedArtistEvent extends HomeEvent {
  final index;
  OnSelectedArtistEvent(this.index);
}
