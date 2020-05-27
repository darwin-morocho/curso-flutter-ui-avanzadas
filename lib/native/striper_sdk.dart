import 'package:flutter/services.dart';
import 'package:meta/meta.dart' show required;

class StripeSDK {
  StripeSDK._internal();
  static StripeSDK _instance = StripeSDK._internal();
  static StripeSDK get instance => _instance;

  final _channel = MethodChannel('ec.dina/stripe_sdk');

  Future<void> init(String pk) async {
    try {
      if (pk == null) throw Exception("pk is null");
      await _channel.invokeMethod('init', {"pk": pk});
      print("Stripe init OK");
    } catch (e) {
      print(e);
    }
  }

  Future<String> makePay({
    @required String clientSecret,
    @required String cardNumber,
    @required int year,
    @required int month,
    @required String cvv,
  }) async {
    try {
      final result = await _channel.invokeMethod('pay', {
        "clientSecret": clientSecret,
        "cardNumber": cardNumber,
        "year": year,
        "month": month,
        "cvv": cvv,
      });

      print("makePay: $result");
      return result['status'];
    } catch (e) {
      print(e);
      return StripeSDKPaymentResult.error;
    }
  }
}

class StripeSDKPaymentResult {
  static const succeeded = "succeeded";
  static const canceled = "canceled";
  static const failed = "failed";
  static const error = "error";
}
