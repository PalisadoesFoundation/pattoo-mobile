import 'package:flutter/material.dart';
import 'package:pattoomobile/views/pages/LoginScreen.dart';
import 'package:pattoomobile/views/pages/HomeScreen.dart';
import 'package:pattoomobile/views/pages/SettingsScreen.dart';
import 'package:pattoomobile/views/pages/ChartScreen.dart';
import 'package:flutter_test/flutter_test.dart';

void main() => runApp(MaterialApp(

  initialRoute: '/',
  routes: {
    '/': (context) => MyHomePage(),
    '/HomeScreen': (context) => HomeScreen(),
  },

),
);


