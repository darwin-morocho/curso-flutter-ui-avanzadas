import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_ui_avanzadas/libs/auth.dart';
import 'package:flutter_ui_avanzadas/pages/home/home_page.dart';
import 'package:flutter_ui_avanzadas/pages/login/widgets/input_text_login.dart';
import 'package:flutter_ui_avanzadas/utils/responsive.dart';
import 'package:flutter_ui_avanzadas/widgets/circle_button.dart';
import 'package:flutter_ui_avanzadas/widgets/rounded_button.dart';

class LoginForm extends StatefulWidget {
  final VoidCallback onSignUp,onForgot;
  const LoginForm({Key key, @required this.onSignUp,@required this.onForgot}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final GlobalKey<InputTextLoginState> _emailKey = GlobalKey();
  final GlobalKey<InputTextLoginState> _passwordKey = GlobalKey();

  void _goTo(BuildContext context, FirebaseUser user) {
    if (user != null) {
      Navigator.pushReplacementNamed(context, HomePage.routeName);
    } else {
      print("login failed");
    }
  }

  Future<void> _submit() async {
    if (_emailKey.currentState.validationOk &&
        _passwordKey.currentState.validationOk) {
      final user = await Auth.instance.login(
        context: context,
        email: _emailKey.currentState.text,
        password: _passwordKey.currentState.text,
      );
      _goTo(context, user);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);

    return SafeArea(
      top: false,
      child: Container(
        width: 330,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
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
            ),
            InputTextLogin(
              key: _passwordKey,
              iconPath: 'assets/pages/login/icons/key.svg',
              placeholder: "Password",
              obscureText: true,
              validator: (text) {
                if (text.trim().length >= 6) {
                  return true;
                }
                return false;
              },
            ),
            Container(
              width: double.infinity,
              alignment: Alignment.centerRight,
              child: CupertinoButton(
                padding: EdgeInsets.symmetric(vertical: 15),
                child: Text(
                  "Forgot password",
                  style: TextStyle(fontFamily: 'sans'),
                ),
                onPressed: widget.onForgot,
              ),
            ),
            SizedBox(
              height: responsive.ip(2),
            ),
            RoundedButton(
              label: "Sign In",
              onPressed: _submit,
            ),
            SizedBox(
              height: responsive.ip(3.3),
            ),
            Text("Or continue with"),
            SizedBox(
              height: responsive.ip(1),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircleButton(
                  size: 55,
                  iconPath: 'assets/pages/login/icons/facebook.svg',
                  backgroundColor: Color(0xff448AFF),
                  onPressed: () async {
                    final user = await Auth.instance.facebook(context);
                    _goTo(context, user);
                  },
                ),
                SizedBox(
                  width: 20,
                ),
                CircleButton(
                  size: 55,
                  iconPath: 'assets/pages/login/icons/google.svg',
                  backgroundColor: Color(0xffFF1744),
                  onPressed: () async {
                    final user = await Auth.instance.google(context);
                    _goTo(context, user);
                  },
                ),
              ],
            ),
            SizedBox(
              height: responsive.ip(2.7),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Don't have an account?"),
                CupertinoButton(
                  child: Text(
                    "Sign Up",
                    style: TextStyle(
                      fontFamily: 'sans',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onPressed: widget.onSignUp,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
