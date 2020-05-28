import 'package:dio/dio.dart';
import 'package:meta/meta.dart' show required;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_ui_avanzadas/libs/auth.dart';

class ResponseCreatePaymentIntent {
  final String id, clientSecret;

  ResponseCreatePaymentIntent({
    @required this.id,
    @required this.clientSecret,
  });

  factory ResponseCreatePaymentIntent.fromJson(Map<String, dynamic> json) {
    return ResponseCreatePaymentIntent(
      id: json['id'],
      clientSecret: json['clientSecret'],
    );
  }
}

class PaymentsAPI {
  PaymentsAPI._internal();
  static PaymentsAPI _instance = PaymentsAPI._internal();
  static PaymentsAPI get instance => _instance;

  final Dio _dio = Dio(
    BaseOptions(baseUrl: 'https://flutter-stripe-backend-demo.herokuapp.com'),
  );

  Future<ResponseCreatePaymentIntent> createPaymentIntent(int amount) async {
    try {
      final IdTokenResult result =
          await (await Auth.instance.user).getIdToken();

      final response = await _dio.post(
        '/create-payment-intent',
        data: {
          "amount": amount,
        },
        options: Options(
          headers: {
            "token": result.token,
          },
        ),
      );

      if (response.statusCode == 200) {
        print(response.data);
        return ResponseCreatePaymentIntent.fromJson(response.data);
      }

      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<bool> checkPayment(String paymentIntentId) async {
    try {
      final IdTokenResult result =
          await (await Auth.instance.user).getIdToken();

      final response = await _dio.post(
        '/check-payment-status',
        data: {
          "paymentIntentId": paymentIntentId,
        },
        options: Options(
          headers: {
            "token": result.token,
          },
        ),
      );

      if (response.statusCode == 200) {
        return response.data['status'] == 'succeeded';
      }

      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
