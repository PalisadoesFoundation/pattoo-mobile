import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pattoomobile/controllers/theme_manager.dart';
import 'package:pattoomobile/utils/app_themes.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: DarkModeWidget(),
        ),
      ),
    );
  }
}

class DarkModeWidget extends StatefulWidget {
  DarkModeWidget({Key key}) : super(key: key);

  @override
  _DarkModeWidgetState createState() => _DarkModeWidgetState();
}

class _DarkModeWidgetState extends State<DarkModeWidget> {
  
  AppTheme theme;

  @override
  Widget build(BuildContext context) {
    bool _lights = Provider.of<ThemeManager>(context, listen: false).getTheme() == AppTheme.Light ? false : true;
    return SwitchListTile(
      title: const Text('Dark Mode'),
      value: _lights,
      onChanged: (bool value) {
        changeTheme();
        setState(() {
          _lights = value;
        });
      },
      secondary: const Icon(Icons.lightbulb_outline),
    );
  }

  void changeTheme() {
    if (this.theme == AppTheme.Light) {
      this.theme = AppTheme.Dark;
      Provider.of<ThemeManager>(context, listen: false).setTheme(this.theme);
    } else {
      this.theme = AppTheme.Light;
      Provider.of<ThemeManager>(context, listen: false).setTheme(this.theme);
    }
  }
}
