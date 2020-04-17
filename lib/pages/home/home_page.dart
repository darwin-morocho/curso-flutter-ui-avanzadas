import 'package:flutter/material.dart';
import 'package:flutter_ui_avanzadas/libs/auth.dart';

class HomePage extends StatefulWidget {
  static final routeName = 'home';
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FlatButton(
          child: Text("Sign out"),
          onPressed: () {
            Auth.instance.logOut(context);
          },
        ),
      ),
    );
  }
}
