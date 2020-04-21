import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ui_avanzadas/libs/auth.dart';

class HomePage extends StatefulWidget {
  static final routeName = 'home';
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Widget _getAlias(String displayName) {
    final List<String> tmp = displayName.split(" ");

    String alias = "";
    if (tmp.length > 0) {
      alias = tmp[0][0];
      if (tmp.length == 2) {
        alias += tmp[1][0];
      }
    }

    return Center(
      child: Text(
        alias,
        style: TextStyle(fontSize: 30),
      ),
    );
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
        child: SafeArea(
          child: FutureBuilder<FirebaseUser>(
              future: Auth.instance.user,
              builder: (BuildContext _, AsyncSnapshot<FirebaseUser> snapshot) {
                if (snapshot.hasData) {
                  final user = snapshot.data;

                  return ListView(
                    children: <Widget>[
                      SizedBox(height: 10),
                      CircleAvatar(
                        radius: 40,
                        child: user.photoUrl != null
                            ? ClipOval(
                                child: Image.network(
                                  user.photoUrl,
                                  width: 74,
                                  height: 74,
                                  fit: BoxFit.contain,
                                ),
                              )
                            : _getAlias(user.displayName),
                      ),
                      SizedBox(height: 10),
                      Text(
                        user.displayName,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        user.email,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text("Network error"),
                  );
                }

                return Center(
                  child: CupertinoActivityIndicator(),
                );
              }),
        ),
      ),
    );
  }
}
