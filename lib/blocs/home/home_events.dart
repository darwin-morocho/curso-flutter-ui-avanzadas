abstract class HomeEvent {}

class CheckDbEvent extends HomeEvent {}

class LoadArtistsEvent extends HomeEvent {}

class DownloadPlayListsEvent extends HomeEvent {}

class OnSelectedArtistEvent extends HomeEvent {
  final id;
  OnSelectedArtistEvent(this.id);
}

class OnSearchChangeEvent extends HomeEvent {
  final text;
  OnSearchChangeEvent(this.text);
}
