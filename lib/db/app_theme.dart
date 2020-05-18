import 'package:flutter/material.dart';
import 'package:flutter_ui_avanzadas/db/db.dart';
import 'package:sembast/sembast.dart';

class MyAppTheme extends ChangeNotifier {
  MyAppTheme._internal();
  static MyAppTheme _instance = MyAppTheme._internal();
  static MyAppTheme get instance => _instance;

  final StoreRef _store = StoreRef.main();
  final Database _db = DB.instance.database;

  bool _darkEnabled;
  bool get darkEnabled => _darkEnabled;

  final Color darkColor = Color(0xff102027);

  ThemeData get theme {
    if (_darkEnabled) {
      return ThemeData(
        scaffoldBackgroundColor: this.darkColor,
        fontFamily: 'sans',
        brightness: Brightness.dark,
      );
    }
    return ThemeData(
      fontFamily: 'sans',
    );
  }

  Future<void> init() async {
    this._darkEnabled =
        (await this._store.record('darkEnabled').get(_db)) as bool ?? false;
  }

  Future<void> setTheme(bool isDarkEnabled) async {
    await this._store.record('darkEnabled').put(_db, isDarkEnabled);
    this._darkEnabled = isDarkEnabled;
    notifyListeners();
  }
}
