import 'package:flutter/material.dart';
import 'package:pattoomobile/controllers/agent_controller.dart';
import 'package:pattoomobile/controllers/client_provider.dart';
import 'package:pattoomobile/controllers/theme_manager.dart';
import 'package:pattoomobile/widgets/userData.dart';
import 'package:pattoomobile/views/pages/ChartLists.dart';
import 'package:pattoomobile/views/pages/SettingsScreen.dart';
import 'package:pattoomobile/widgets/AgentsList.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    List<Widget> children = [
      AgentsList(),
      DataDisplay(),
      ChartList(),
      SettingsScreen()
    ];
    return ClientProvider(
        uri: Provider.of<AgentsManager>(context).loaded
            ? Provider.of<AgentsManager>(context).httpLink + "/graphql"
            : "None",
        child: Scaffold(
          body: children[_currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            onTap: onTabTapped,
            currentIndex: _currentIndex,
            items: [
              BottomNavigationBarItem(
                  icon: new Icon(Icons.home),
                  title: new Text('Home'),
                  activeIcon: new Icon(
                    Icons.home,
                    color: Provider.of<ThemeManager>(context)
                        .themeData
                        .accentColor,
                  )),
              BottomNavigationBarItem(
                icon: new Icon(Icons.favorite),
                title: new Text('Favorites'),
                activeIcon: new Icon(
                  Icons.favorite,
                  color:
                      Provider.of<ThemeManager>(context).themeData.accentColor,
                ),
              ),
              BottomNavigationBarItem(
                icon: new Icon(Icons.multiline_chart),
                title: new Text('Charts'),
                activeIcon: new Icon(
                  Icons.favorite,
                  color:
                      Provider.of<ThemeManager>(context).themeData.accentColor,
                ),
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.settings),
                  title: Text('Settings'),
                  activeIcon: Icon(Icons.settings,
                      color: Provider.of<ThemeManager>(context)
                          .themeData
                          .accentColor))
            ],
          ),
        ));
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
