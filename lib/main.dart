import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ui_avanzadas/pages/home/home_page.dart';
import 'package:flutter_ui_avanzadas/pages/login/login_page.dart';
import 'package:flutter_ui_avanzadas/pages/splash/splash_page.dart';
import 'package:flutter_ui_avanzadas/sembast/db.dart';
import 'package:flutter_ui_avanzadas/utils/my-scroll-behavior.dart';
import 'package:flutter_ui_avanzadas/utils/theme.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppTheme.instance.init();
  await DB.instance.init();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void dispose() {
    DB.instance.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppTheme.instance,
      child: Consumer<AppTheme>(builder: (_, appTheme, child) {
        return MaterialApp(
          builder: (_, child) {
            SystemChrome.setSystemUIOverlayStyle(appTheme.darkEnabled
                ? SystemUiOverlayStyle.light
                : SystemUiOverlayStyle.dark);

            return ScrollConfiguration(
              behavior: MyScrollBehavior(),
              child: child,
            );
          },
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          theme: appTheme.themeData,
          home: SplashPage(),
          routes: {
            HomePage.routeName: (_) => HomePage(),
            SplashPage.routeName: (_) => SplashPage(),
            LoginPage.routeName: (_) => LoginPage(),
          },
        );
      }),
    );
  }
}
