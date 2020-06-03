import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pattoomobile/controllers/theme_manager.dart';
import 'package:pattoomobile/views/pages/HomeScreen.dart';
import 'package:pattoomobile/views/pages/LoginScreen.dart';
import 'package:pattoomobile/views/pages/ListScreen.dart';
import 'package:pattoomobile/views/pages/SettingsScreen.dart';

void main() => runApp(App());

class App extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
   return ChangeNotifierProvider<ThemeManager>(
     //Here we provide our ThemeManager to child widget tree
     create: (_) => ThemeManager(),
     //Consumer will call builder method each time ThemeManager
     //calls notifyListeners()
     child: Consumer<ThemeManager>(builder: (context, manager, _) {
       return MaterialApp(
           debugShowCheckedModeBanner: false,
           theme: manager.themeData,
           initialRoute: '/',
           routes: {
              '/': (context) => LoginScreen(),
              '/Homescreen': (context) => HomeScreen(),
              '/Listscreen': (context) => List()
              });
            }),
          );
        }
      }
