import 'package:dio/dio.dart';
import 'package:flutter_ui_avanzadas/models/artist.dart';
import 'package:flutter_ui_avanzadas/models/track.dart';

class DeezerAPI {
  DeezerAPI._internal();
  static DeezerAPI _instance = DeezerAPI._internal();
  static DeezerAPI get instance => _instance;

  Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.deezer.com',
      connectTimeout: 3000,
      receiveTimeout: 5000,
    ),
  );

  Future<List<Artist>> get artists async {
    try {
      final response = await _dio.get("/genre/0/artists");
      if (response.statusCode == 200) {
        final artists = (response.data['data'] as List)
            .map((item) => Artist.fromJson(item))
            .toList();
        return artists;
      }
      return null;
    } catch (e) {
      print("error when trying to get artists: $e");
      return null;
    }
  }

  Future<List<Track>> getTracks(int artistId) async {
    try {
      //https://api.deezer.com/artist/10583405/top?limit=50
      final response = await _dio.get('/artist/$artistId/top?limit=20');
      if (response.statusCode == 200) {
        return (response.data['data'] as List)
            .map((json) => Track.fromJson(artistId, json))
            .toList();
      }
      return null;
    } catch (e) {
      print("error when trying to get artists: $e");
      return null;
    }
  }
}
