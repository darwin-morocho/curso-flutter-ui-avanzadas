import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_form.dart';
import 'package:flutter_credit_card/credit_card_model.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:flutter_ui_avanzadas/api/payments_api.dart';
import 'package:flutter_ui_avanzadas/native/striper_sdk.dart';
import 'package:flutter_ui_avanzadas/utils/dialogs.dart';
import 'package:flutter_ui_avanzadas/widgets/rounded_button.dart';
import 'package:overlay_support/overlay_support.dart';

class CheckOutPage extends StatefulWidget {
  final double price;

  const CheckOutPage({Key key, @required this.price}) : super(key: key);

  @override
  _CheckOutPageState createState() => _CheckOutPageState();
}

class _CheckOutPageState extends State<CheckOutPage> {
  String _cardNumber = '', _cardHolder = '', _expiryDate = '', _cvv = '';
  int _year, _month;
  bool _isOk = false;

  void _check() {
    if (_cardNumber.length != 19) {
      _isOk = false;
      return;
    }

    if (_cvv.length < 3) {
      _isOk = false;
      return;
    }

    if (_expiryDate.length != 5) {
      _isOk = false;
      return;
    }

    List<String> tmp = _expiryDate.split("/");
    final int month = int.parse(tmp[0]);

    if (month > 12) {
      _isOk = false;
      return;
    }
    final int year = int.parse("20" + tmp[1]);

    final DateTime expiryDate = DateTime(year, month, 1);

    DateTime currentDate = DateTime.now().toLocal();
    currentDate = DateTime(currentDate.year, currentDate.month, 1);

    if (!expiryDate.isAfter(currentDate)) {
      _isOk = false;
      return;
    }

    _year = year;
    _month = month;

    _isOk = true;
  }

  Future<void> _createPaymentIntent() async {
    ProgressDialog dialog = ProgressDialog(context);
    final int amount = (widget.price * 100).ceil();
    dialog.show();
    final ResponseCreatePaymentIntent response =
        await PaymentsAPI.instance.createPaymentIntent(amount);

    if (response != null) {
      await this._makePay(response);
      dialog.dismiss();
    } else {
      showSimpleNotification(
        Text(
          "API Fail",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        background: Colors.redAccent,
      );
      dialog.dismiss();
    }
  }

  Future<void> _makePay(ResponseCreatePaymentIntent response) async {
    final String status = await StripeSDK.instance.makePay(
      clientSecret: response.clientSecret,
      cardNumber: _cardNumber,
      year: _year,
      month: _month,
      cvv: _cvv,
    );

    if (status == StripeSDKPaymentResult.succeeded) {
      showSimpleNotification(
        Text(
          "GOOD payment successful",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        background: Colors.green,
      );
    } else {
      showSimpleNotification(
        Text(
          status,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        background: Colors.redAccent,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                CreditCardWidget(
                  cardNumber: _cardNumber,
                  expiryDate: _expiryDate,
                  cardHolderName: _cardHolder,
                  cvvCode: _cvv,
                  showBackView: false,
                  height: 200,
                ),
                CreditCardForm(
                  themeColor: Colors.red,
                  onCreditCardModelChange: (CreditCardModel data) {
                    _cardNumber = data.cardNumber;
                    _cardHolder = data.cardHolderName;
                    _expiryDate = data.expiryDate;
                    _cvv = data.cvvCode;
                    _check();
                    setState(() {});
                  },
                ),
                SizedBox(height: 10),
                RoundedButton(
                  label: "PAY \$${widget.price.toStringAsFixed(2)}",
                  onPressed: _isOk
                      ? () {
                          this._createPaymentIntent();
                        }
                      : null,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
