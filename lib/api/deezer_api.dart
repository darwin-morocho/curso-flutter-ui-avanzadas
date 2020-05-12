import 'package:dio/dio.dart';
import 'package:flutter_ui_avanzadas/models/artist.dart';
import 'package:flutter_ui_avanzadas/models/track.dart';

class DeezerAPI {
  DeezerAPI._internal();

  static DeezerAPI _instance = DeezerAPI._internal();
  static DeezerAPI get instance => _instance;

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.deezer.com',
      connectTimeout: 5000,
      receiveTimeout: 10000,
    ),
  );

  Future<List<Artist>> getArtist() async {
    try {
      final Response response = await _dio.get('/genre/0/artists');

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

  Future<List<Track>> getTracks(int artistId) async {
    try {
      final Response response =
          await _dio.get('/artist/$artistId/top?limit=20');

      if (response.statusCode == 200) {
        return (response.data['data'] as List)
            .map((json) => Track.fromJson(json))
            .toList();
      }

      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
