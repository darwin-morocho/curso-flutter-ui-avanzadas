import 'package:dio/dio.dart';
import 'package:flutter_ui_avanzadas/models/artist.dart';

class DeezerAPI {
  DeezerAPI._internal();

  static DeezerAPI _instance = DeezerAPI._internal();
  static DeezerAPI get instance => _instance;

  final Dio _dio = Dio();

  Future<List<Artist>> getArtist() async {
    try {
      final Response response =
          await _dio.get('https://api.deezer.com/genre/0/artists');

      if (response.statusCode == 200) {
        final List<Artist> artists = (response.data['data'] as List)
            .map<Artist>((json) => Artist.fromJson(json))
            .toList();

        return artists;
      }
      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
