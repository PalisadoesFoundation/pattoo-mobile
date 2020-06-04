
import 'package:flutter/material.dart';


class MyApp extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: ShowFavWidget(),
        ),
      ),
    );
  }
}

class ShowFavWidget extends StatefulWidget {
  ShowFavWidget({Key key}) : super(key: key);

  @override
  _ShowFavWidgetState createState() => _ShowFavWidgetState();
}

class _ShowFavWidgetState extends State<ShowFavWidget> {
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
      secondary: const Icon(Icons.favorite_border),
    );
  }
}