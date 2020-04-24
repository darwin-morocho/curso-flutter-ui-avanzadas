import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_ui_avanzadas/libs/auth.dart';
import 'package:flutter_ui_avanzadas/pages/home/home_page.dart';
import 'package:flutter_ui_avanzadas/pages/login/widgets/input_text_login.dart';
import 'package:flutter_ui_avanzadas/utils/app_colors.dart';
import 'package:flutter_ui_avanzadas/utils/responsive.dart';
import 'package:flutter_ui_avanzadas/widgets/rounded_button.dart';

class RegisterForm extends StatefulWidget {
  final VoidCallback onGoToLogin;
  const RegisterForm({Key key, @required this.onGoToLogin}) : super(key: key);

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  bool _agree = false;

  void _goTo(BuildContext context, FirebaseUser user) {
    if (user != null) {
      Navigator.pushReplacementNamed(context, HomePage.routeName);
    } else {
      print("login failed");
    }
  }

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);

    return Align(
      alignment: Alignment.bottomCenter,
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
                iconPath: 'assets/pages/login/icons/avatar.svg',
                placeholder: "Username",
              ),
              SizedBox(
                height: responsive.ip(2),
              ),
              InputTextLogin(
                iconPath: 'assets/pages/login/icons/email.svg',
                placeholder: "Email Address",
              ),
              SizedBox(
                height: responsive.ip(2),
              ),
              InputTextLogin(
                iconPath: 'assets/pages/login/icons/key.svg',
                placeholder: "Password",
              ),
              SizedBox(
                height: responsive.ip(2),
              ),
              InputTextLogin(
                iconPath: 'assets/pages/login/icons/key.svg',
                placeholder: "Confirm Password",
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
                    onPressed: () {},
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
}
