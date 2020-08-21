import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pattoomobile/widgets/SettingsContainer.dart';

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
        centerTitle: true,
        title: Text(
          "Settings",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
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
