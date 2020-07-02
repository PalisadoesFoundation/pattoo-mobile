import 'package:flutter/material.dart';
import 'package:pattoomobile/views/pages/LoginScreen.dart';
<<<<<<< HEAD
import 'package:pattoomobile/views/pages/HomeScreen.dart';
import 'package:pattoomobile/views/pages/SettingsScreen.dart';
import 'package:pattoomobile/views/pages/ChartScreen.dart';
import 'package:flutter_test/flutter_test.dart';
=======
>>>>>>> repo-a/master

void main() => runApp(MaterialApp(

<<<<<<< HEAD
  initialRoute: '/',
  routes: {
    '/': (context) => SettingsScreen(),
    '/HomeScreen': (context) => HomeScreen(),
  },

),
);


=======
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: new LoginScreen(),
    );
  }
}
>>>>>>> repo-a/master
