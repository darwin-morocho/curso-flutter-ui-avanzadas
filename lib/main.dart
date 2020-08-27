import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ui_avanzadas/pages/home/home_page.dart';
import 'package:flutter_ui_avanzadas/pages/login/login_page.dart';
import 'package:flutter_ui_avanzadas/pages/splash/splash_page.dart';

void main() {
  //await Firebase.initializeApp();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initialization,
        builder: (_, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text("Firebase error"));
          }

          if (snapshot.connectionState == ConnectionState.done) {
            return MaterialApp(
              title: 'Flutter Demo',
              debugShowCheckedModeBanner: false,
              theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'sans'),
              home: SplashPage(),
              routes: {
                HomePage.routeName: (_) => HomePage(),
                SplashPage.routeName: (_) => SplashPage(),
                LoginPage.routeName: (_) => LoginPage(),
              },
            );
          }

          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
