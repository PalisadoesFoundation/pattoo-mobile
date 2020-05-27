import 'package:flutter/material.dart';
import 'package:pattoomobile/views/pages/LoginScreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: new LoginScreen(),
    );
  }
}
