import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_colors.dart';

enum CurrentAppTheme { light, dark }

class AppTheme extends ChangeNotifier {
  bool _darkEnabled = false;
  final String _key = "DARK_MODE_ENABLED";
  SharedPreferences _settings;

  Future<void> init() async {
    _settings = await SharedPreferences.getInstance();
    _darkEnabled = _settings.getBool(_key) ?? false;
  }

  ThemeData get themeData {
    if (!_darkEnabled) {
      return ThemeData(fontFamily: 'sans');
    }
    return ThemeData(
      brightness: Brightness.dark,
      fontFamily: 'sans',
      primaryColor: Colors.redAccent,
      toggleableActiveColor: AppColors.primary,
      scaffoldBackgroundColor: Color(0xff102027),
    );
  }

  set darkEnabled(bool enabled) {
    this._darkEnabled = enabled;
    _settings.setBool(_key, enabled);
    notifyListeners();
  }

  AppTheme._internal();

  static AppTheme _instance = AppTheme._internal();
  static AppTheme get instance => _instance;
  bool get darkEnabled => _darkEnabled;
}
