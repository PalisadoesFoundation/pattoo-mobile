import 'package:flutter/material.dart';
import 'package:pattoomobile/views/pages/LoginScreen.dart';
import 'package:pattoomobile/views/pages/HomeScreen.dart';

void main() => runApp(MaterialApp(
  initialRoute: '/home',
  routes: {
    '/': (context) => LoginScreen(),
    '/Homescreen': (context) => HomeScreen(),
  },

));
