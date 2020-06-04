
import 'package:flutter/material.dart';


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
  bool _lights = false;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: const Text('Dark Mode'),
      value: _lights,
      onChanged: (bool value) {
        setState(() {
          _lights = value;
        });
      },
      secondary: const Icon(Icons.lightbulb_outline),
    );
  }
}