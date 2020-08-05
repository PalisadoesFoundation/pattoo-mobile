import 'package:flutter/material.dart';
import 'package:pattoomobile/controllers/agent_controller.dart';
import 'package:pattoomobile/controllers/client_provider.dart';
import 'file:///C:/Users/Toast/Desktop/Calico/lib/widgets/userData.dart';
import 'package:pattoomobile/views/pages/SettingsScreen.dart';
import 'package:pattoomobile/widgets/AgentsList.dart';
import 'package:pattoomobile/widgets/userDisplay.dart';
import 'package:provider/provider.dart';
import 'package:pattoomobile/controllers/userState.dart';


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
      //MainFav(),
      DataDisplay(),
      SettingsScreen()
    ];
    return ClientProvider(
        uri: Provider.of<AgentsManager>(context).loaded
            ? Provider.of<AgentsManager>(context).httpLink
            : "None",
        child: Scaffold(
          body: children[_currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            onTap: onTabTapped,
            currentIndex: _currentIndex,
            items: [
              BottomNavigationBarItem(
                icon: new Icon(Icons.home),
                title: new Text('Home'),
              ),
              BottomNavigationBarItem(
                icon: new Icon(Icons.favorite),
                title: new Text('Favorites'),
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.settings), title: Text('Settings'))
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
