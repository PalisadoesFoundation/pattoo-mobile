
import 'package:flutter/material.dart';

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
      title: const Text('Show Favourites'),
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