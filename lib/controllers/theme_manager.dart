import 'package:flutter/material.dart';
import 'package:pattoomobile/utils/app_themes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeManager with ChangeNotifier {
  ThemeData _themeData;
  AppTheme localTheme;
  final _kThemePreference = "theme_preference";
  final theme_state = "theme_state";
  ThemeManager() {
    // We load theme at the start
    _loadTheme();
  }

  /// Use this method on UI to get selected theme.
  ThemeData get themeData {
    if (_themeData == null) {
      _themeData = appThemeData[AppTheme.Light];
      localTheme = AppTheme.Light;
    }
    return _themeData;
  }

  AppTheme getTheme() {
    return this.localTheme;
  }

  /// Sets theme and notifies listeners about change.
  setTheme(AppTheme theme) async {
    _themeData = appThemeData[theme];
    localTheme = theme;
    var prefs = await SharedPreferences.getInstance();
    prefs.setInt(_kThemePreference, AppTheme.values.indexOf(theme));
    prefs.setString(theme_state, localTheme == AppTheme.Light ? "light" : "dark");
    // Here we notify listeners that theme changed
    // so UI have to be rebuild
    notifyListeners();
  }

  void _loadTheme() {
    debugPrint("Entered loadTheme()");
    SharedPreferences.getInstance().then((prefs) {
      int preferredTheme = prefs.getInt(_kThemePreference) ?? 0;
      String prefState = prefs.getString(theme_state) ?? "light";
      _themeData = appThemeData[AppTheme.values[preferredTheme]];
      localTheme = prefState == "light" ? AppTheme.Light : AppTheme.Dark;
      // Once theme is loaded - notify listeners to update UI
      notifyListeners();
    });
  }
}
