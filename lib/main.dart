import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pattoomobile/controllers/agent_controller.dart';
import 'package:provider/provider.dart';
import 'package:pattoomobile/controllers/theme_manager.dart';
import 'package:pattoomobile/views/pages/HomeScreen.dart';
import 'package:pattoomobile/views/pages/LoginScreen.dart';

import 'controllers/userState.dart';

void main() {
  runApp(DevicePreview(child: App()));
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<ThemeManager>(create: (_) => ThemeManager()),
          ChangeNotifierProvider<AgentsManager>(create: (_) => AgentsManager()),
          ChangeNotifierProvider<UserState>(create: (_) => UserState())
        ],
        child: Consumer<AgentsManager>(builder: (context, agent, _) {
          return Consumer<ThemeManager>(builder: (context, manager, _) {
            return MaterialApp(
                builder: DevicePreview.appBuilder,
                debugShowCheckedModeBanner: false,
                theme: manager.themeData,
                initialRoute: '/',
                routes: {
                  '/': (context) => LoginScreen(),
                  '/HomeScreen': (context) => HomeScreen(),
                });
          });
        }));
  }
}
