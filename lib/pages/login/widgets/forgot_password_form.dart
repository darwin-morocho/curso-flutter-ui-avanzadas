import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_ui_avanzadas/libs/auth.dart';
import 'package:flutter_ui_avanzadas/pages/login/widgets/input_text_login.dart';
import 'package:flutter_ui_avanzadas/utils/app_colors.dart';
import 'package:flutter_ui_avanzadas/utils/dialogs.dart';
import 'package:flutter_ui_avanzadas/utils/responsive.dart';
import 'package:flutter_ui_avanzadas/widgets/rounded_button.dart';

class ForgotPasswordForm extends StatefulWidget {
  final VoidCallback onLogIn;
  const ForgotPasswordForm({Key key, @required this.onLogIn}) : super(key: key);

  @override
  _ForgotPasswordFormState createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends State<ForgotPasswordForm> {
  final GlobalKey<InputTextLoginState> _emailKey = GlobalKey();
  bool _sent = false;

  Future<void> _submit() async {
    if (_emailKey.currentState.validationOk) {
      await Auth.instance.sendPasswordResetEmail(
          context: context, email: _emailKey.currentState.text);
      setState(() {
        _sent = true;
      });
    } else {
      Dialogs.alert(context, description: "Insert a valid email");
    }
  }

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);

    return SafeArea(
      top: false,
      child: Container(
        constraints: BoxConstraints(maxWidth: 420),
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              "Password Reset",
              style: TextStyle(
                  fontFamily: 'raleway',
                  color: AppColors.primary,
                  fontSize: responsive.ip(2.4),
                  fontWeight: FontWeight.bold),
            ),
            Text(
              _sent
                  ? "We have sent an email to recover your password"
                  : "Lorem ipsum dolor sit amet, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
              style: TextStyle(
                fontSize: responsive.ip(1.4),
                fontWeight: FontWeight.w300,
              ),
            ),
            SizedBox(
              height: responsive.ip(2),
            ),
            if (!_sent) ...[
              InputTextLogin(
                key: _emailKey,
                iconPath: 'assets/pages/login/icons/email.svg',
                placeholder: "Email Address",
                validator: (text) {
                  if (text.contains("@")) {
                    return true;
                  }
                  return false;
                },
              ),
              SizedBox(
                height: responsive.ip(2),
              )
            ],
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                FlatButton(
                  child: Text("← Back to Log In"),
                  onPressed: widget.onLogIn,
                ),
                if (!_sent) ...[
                  SizedBox(width: 15),
                  RoundedButton(
                    label: "Send",
                    onPressed: _submit,
                  )
                ]
              ],
            ),
            SizedBox(
              height: responsive.ip(3.3),
            ),
          ],
        ),
      ),
    );
  }
}
