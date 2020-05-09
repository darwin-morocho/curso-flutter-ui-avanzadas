import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../libs/auth.dart';

class MyAvatar extends StatelessWidget {
  final VoidCallback  onPressed;
  const MyAvatar({Key key, @required this.onPressed}) : super(key: key);

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
        style: TextStyle(
          fontSize: 22,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<FirebaseUser>(
        future: Auth.instance.user,
        builder: (BuildContext _, AsyncSnapshot<FirebaseUser> snapshot) {
          if (snapshot.hasData) {
            final user = snapshot.data;

            return CupertinoButton(
              onPressed: this.onPressed,
              padding: EdgeInsets.zero,
              child: CircleAvatar(
                radius: 30,
                backgroundColor: Color(0xfff50057),
                child: user.photoUrl != null
                    ? ClipOval(
                        child: Image.network(
                          user.photoUrl,
                          width: 58,
                          height: 58,
                          fit: BoxFit.contain,
                        ),
                      )
                    : _getAlias(user.displayName),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Network error"),
            );
          }

          return Center(
            child: CupertinoActivityIndicator(),
          );
        });
  }
}
