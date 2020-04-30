import 'package:dio/dio.dart';
import 'package:flutter_ui_avanzadas/models/artist.dart';

class DeezerAPI {
  DeezerAPI._internal();
  static DeezerAPI get instance => DeezerAPI._internal();

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
}
