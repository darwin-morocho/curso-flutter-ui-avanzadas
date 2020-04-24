import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_ui_avanzadas/libs/auth.dart';
import 'package:flutter_ui_avanzadas/pages/home/home_page.dart';
import 'package:flutter_ui_avanzadas/pages/login/widgets/input_text_login.dart';
import 'package:flutter_ui_avanzadas/utils/app_colors.dart';
import 'package:flutter_ui_avanzadas/utils/dialogs.dart';
import 'package:flutter_ui_avanzadas/utils/responsive.dart';
import 'package:flutter_ui_avanzadas/widgets/rounded_button.dart';

class RegisterForm extends StatefulWidget {
  final VoidCallback onLogIn;
  const RegisterForm({Key key, @required this.onLogIn}) : super(key: key);

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  bool _agree = false;

  final GlobalKey<InputTextLoginState> _usernameKey = GlobalKey();
  final GlobalKey<InputTextLoginState> _emailKey = GlobalKey();
  final GlobalKey<InputTextLoginState> _passwordKey = GlobalKey();
  final GlobalKey<InputTextLoginState> _vpasswordKey = GlobalKey();

  Future<void> _submit() async {
    if (_usernameKey.currentState.validationOk &&
        _emailKey.currentState.validationOk &&
        _passwordKey.currentState.validationOk &&
        _vpasswordKey.currentState.validationOk) {
      if (!_agree) {
        Dialogs.alert(context,
            description: "You must accept the terms and conditions");
        return;
      }
      final user = await Auth.instance.signUp(
        context: context,
        username: _usernameKey.currentState.text,
        email: _emailKey.currentState.text,
        password: _passwordKey.currentState.text,
      );
      if (user != null) {
        Navigator.pushReplacementNamed(context, HomePage.routeName);
      } else {
        print("login failed");
      }
    } else {
      if (!_agree) {
        Dialogs.alert(context, description: "Some fields are invalid");
        return;
      }
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
              "New Account",
              style: TextStyle(
                  fontFamily: 'raleway',
                  color: AppColors.primary,
                  fontSize: responsive.ip(2.4),
                  fontWeight: FontWeight.bold),
            ),
            Text(
              "Lorem ipsum dolor sit amet, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
              style: TextStyle(
                fontSize: responsive.ip(1.4),
                fontWeight: FontWeight.w300,
              ),
            ),
            SizedBox(
              height: responsive.ip(2),
            ),
            InputTextLogin(
              key: _usernameKey,
              iconPath: 'assets/pages/login/icons/avatar.svg',
              placeholder: "Username",
              validator: (text) {
                if (text.trim().length > 0) {
                  return true;
                }
                return false;
              },
            ),
            SizedBox(
              height: responsive.ip(2),
            ),
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
              obscureText: true,
              iconPath: 'assets/pages/login/icons/key.svg',
              placeholder: "Password",
              validator: (text) {
                if (text.trim().length >= 6) {
                  return true;
                }
                return false;
              },
            ),
            SizedBox(
              height: responsive.ip(2),
            ),
            InputTextLogin(
              key: _vpasswordKey,
              obscureText: true,
              iconPath: 'assets/pages/login/icons/key.svg',
              placeholder: "Confirm Password",
              validator: (text) {
                if (text.trim().length >= 6) {
                  return true;
                }
                return false;
              },
            ),
            SizedBox(
              height: responsive.ip(2),
            ),
            DefaultTextStyle(
              style: TextStyle(
                fontSize: responsive.ip(1.3),
                color: Theme.of(context).textTheme.overline.color,
              ),
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      setState(() {
                        _agree = !_agree;
                      });
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(
                          _agree
                              ? Icons.check_circle
                              : Icons.radio_button_unchecked,
                          color: _agree ? AppColors.primary : Color(0xffcccccc),
                        ),
                        SizedBox(width: 10),
                        Text("I agree the to the "),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {},
                    child: Text(
                      " Terms of Services",
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(" & "),
                  InkWell(
                    onTap: () {},
                    child: Text(
                      " Privacy Policy",
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: responsive.ip(3),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                FlatButton(
                  child: Text("← Back to Log In"),
                  onPressed: widget.onLogIn,
                ),
                SizedBox(width: 15),
                RoundedButton(
                  label: "Sign Up",
                  onPressed: _submit,
                )
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
