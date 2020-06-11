
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pattoomobile/widgets/DarkModeSwitch.dart';
import 'package:pattoomobile/widgets/ShowFavSwitch.dart';
import 'package:pattoomobile/widgets/SettingsContainer.dart';
import 'package:pattoomobile/widgets/DropdownWidget.dart';
import 'package:pattoomobile/controllers/theme_manager.dart';
import 'package:pattoomobile/controllers/agent_controller.dart';
import 'package:provider/provider.dart';
import 'package:pattoomobile/widgets/LoginForm.dart';
import 'package:pattoomobile/widgets/AgentInput.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isSwitched = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
        backgroundColor:  Provider.of<ThemeManager>(context,listen: false).themeData.backgroundColor,

      ),
      body:
      Center(
        child: Stack(
          children: <Widget>[
            SettingsContainer(),
  ],
      ),
      ),

    );
  }
}
//MyStatefulWidget(),
