
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pattoomobile/widgets/DarkModeSwitch.dart';
import 'package:pattoomobile/widgets/ShowFavSwitch.dart';
import 'package:pattoomobile/widgets/SettingsContainer.dart';
import 'package:pattoomobile/widgets/DropdownWidget.dart';
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
      ),
      body:
      Center(
        child: Stack(
          children: <Widget>[
            SettingsContainer(),
            Container(
              margin: const EdgeInsets.only(top: 50.0),
                child: Padding(
                padding: EdgeInsets.all(30.0),
                child: DarkModeWidget(),
              ),
            ),
             Container(
               margin: const EdgeInsets.only(top: 100.0),
               child: Padding(
                 padding: EdgeInsets.all(30.0),
                 child: ShowFavWidget(),
               ),
             ),
             Container(
              margin: const EdgeInsets.only(top: 150.0),
              child: Padding(
                padding: EdgeInsets.fromLTRB(46, 30, 0, 0),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.business,
                      color: Colors.grey,),
                    SizedBox(
                      width: 33.0,
                      height: 10.0,
                    ),
                    Container(
                      child:
                      Text(
                        'Source',
                        style: TextStyle(fontSize: 15.5),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .05,
                      width: MediaQuery.of(context).size.width * .3,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

    );
  }
}
//MyStatefulWidget(),
