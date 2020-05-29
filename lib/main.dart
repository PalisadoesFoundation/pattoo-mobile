import 'package:flutter/material.dart';
import 'package:pattoomobile/views/pages/LoginScreen.dart';
import 'package:pattoomobile/views/pages/HomeScreen.dart';
import 'package:pattoomobile/views/pages/ListScreen.dart';

void main() => runApp(MaterialApp(
  initialRoute: '/home',
  routes: {
    '/': (context) => List(),
    '/Homescreen': (context) => HomeScreen(),
    '/Listscreen': (context) => List(),
  },
));
