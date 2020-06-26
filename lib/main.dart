import 'package:flutter/material.dart';
import 'package:pattoomobile/controllers/agent_controller.dart';
import 'package:provider/provider.dart';
import 'package:pattoomobile/controllers/theme_manager.dart';
import 'package:pattoomobile/views/pages/HomeScreen.dart';
import 'package:pattoomobile/views/pages/LoginScreen.dart';
import 'package:pattoomobile/views/pages/SettingsScreen.dart';

void main() {
  runApp(App());
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<ThemeManager>(create: (_) => ThemeManager()),
          ChangeNotifierProvider<AgentsManager>(create: (_) => AgentsManager())
        ],
        child: Consumer<AgentsManager>(builder: (context, agent, _) {
          return Consumer<ThemeManager>(builder: (context, manager, _) {
            return MaterialApp(
                debugShowCheckedModeBanner: false,
                theme: manager.themeData,
                initialRoute: '/',
                routes: {
                  '/': (context) => LoginScreen(),
                  '/HomeScreen': (context) => HomeScreen(),
                  '/Settings': (context) => SettingsScreen()
                });
          });
        }));
  }
}
