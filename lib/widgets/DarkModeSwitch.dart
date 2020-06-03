
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pattoomobile/controllers/theme_manager.dart';
import 'package:pattoomobile/utils/app_themes.dart';

void main() => runApp(MyApp());

/// This Widget is the main application widget.
class MyApp extends StatelessWidget {
  static const String _title = 'Flutter Code Sample';
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: Scaffold(
        appBar: AppBar(title: const Text(_title)),
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
  bool _lights = false;
  AppTheme theme;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: const Text('Dark Mode'),
      value: _lights,
      onChanged: (bool value) {
         this.changeTheme();

      },
      secondary: const Icon(Icons.lightbulb_outline),
    );
  }

    void changeTheme(){
    if (this.theme == AppTheme.Light){
      this.theme = AppTheme.Dark;
      Provider.of<ThemeManager>(context,listen: false).setTheme(this.theme);
    }
    else{
      
      this.theme = AppTheme.Light;
      Provider.of<ThemeManager>(context,listen: false).setTheme(this.theme);
    }
  }
}