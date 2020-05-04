import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_ui_avanzadas/libs/auth.dart';
import 'package:flutter_ui_avanzadas/pages/home/home_page.dart';
import 'package:flutter_ui_avanzadas/pages/login/widgets/input_text_login.dart';
import 'package:flutter_ui_avanzadas/utils/app_colors.dart';
import 'package:flutter_ui_avanzadas/utils/dialogs.dart';
import 'package:flutter_ui_avanzadas/utils/extras.dart';
import 'package:flutter_ui_avanzadas/utils/responsive.dart';
import 'package:flutter_ui_avanzadas/widgets/rounded_button.dart';

class RegisterForm extends StatefulWidget {
  final VoidCallback onGoToLogin;
  final Alignment alignment;
  const RegisterForm(
      {Key key,
      @required this.onGoToLogin,
      this.alignment = Alignment.bottomCenter})
      : super(key: key);

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm>  with AutomaticKeepAliveClientMixin{
  bool _agree = false;

  final GlobalKey<InputTextLoginState> _usernameKey = GlobalKey();
  final GlobalKey<InputTextLoginState> _emailKey = GlobalKey();
  final GlobalKey<InputTextLoginState> _passwordKey = GlobalKey();
  final GlobalKey<InputTextLoginState> _vpasswordKey = GlobalKey();

  void _goTo(FirebaseUser user) {
    if (user != null) {
      Navigator.pushReplacementNamed(context, HomePage.routeName);
    } else {
      print("register failed");
    }
  }

  _submit() async {
    final String username = _usernameKey.currentState.value;
    final String email = _emailKey.currentState.value;
    final String password = _passwordKey.currentState.value;
    final String vpassword = _vpasswordKey.currentState.value;

    final bool usernameOk = _usernameKey.currentState.isOk;
    final bool emailOk = _emailKey.currentState.isOk;
    final bool passwordOk = _passwordKey.currentState.isOk;
    final bool vpasswordOk = _vpasswordKey.currentState.isOk;

    if (usernameOk && emailOk && passwordOk && vpasswordOk) {
      if (_agree) {
        final FirebaseUser user = await Auth.instance.signUp(
          context,
          username: username,
          email: email,
          password: password,
        );

        _goTo(user);
      } else {
        Dialogs.alert(context,
            description: "you need to accept the terms and conditions");
      }
    } else {
      Dialogs.alert(context, description: "Some fields are invalid");
    }
  }

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);

    return Align(
      alignment: widget.alignment,
      child: SafeArea(
        top: false,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15),
          constraints: BoxConstraints(maxWidth: 400),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                "New Account",
                style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 30,
                    fontFamily: 'raleway',
                    fontWeight: FontWeight.bold),
              ),
              Text(
                "Lorem ipsum dolor sit amet,  sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
                style: TextStyle(
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
                  return text.trim().length > 0;
                },
              ),
              SizedBox(
                height: responsive.ip(2),
              ),
              InputTextLogin(
                key: _emailKey,
                iconPath: 'assets/pages/login/icons/email.svg',
                placeholder: "Email Address",
                keyboardType: TextInputType.emailAddress,
                validator: (text) => Extras.isValidEmail(text),
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
                  _vpasswordKey.currentState?.checkValidation();
                  return text.trim().length >= 6;
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
                  return text.trim().length >= 6 &&
                      _vpasswordKey.currentState.value ==
                          _passwordKey.currentState.value;
                },
              ),
              SizedBox(
                height: responsive.ip(2),
              ),
              DefaultTextStyle(
                style: TextStyle(
                    fontSize: responsive.ip(1.3),
                    color: Theme.of(context).textTheme.subtitle.color),
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: <Widget>[
                    Checkbox(
                      value: _agree,
                      onChanged: (isChecked) {
                        setState(() {
                          _agree = isChecked;
                        });
                      },
                    ),
                    Text("I Agree to the "),
                    InkWell(
                      onTap: () {},
                      child: Text(
                        "Terms of services",
                        style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Text(" & "),
                    InkWell(
                      onTap: () {},
                      child: Text(
                        "Privacy Policy",
                        style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: responsive.ip(2),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  FlatButton(
                    onPressed: widget.onGoToLogin,
                    child: Text("← Back to Log In"),
                  ),
                  SizedBox(width: 10),
                  RoundedButton(
                    label: "Sign Up",
                    onPressed: _submit,
                  ),
                ],
              ),
              SizedBox(
                height: responsive.ip(2),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => false;
}
