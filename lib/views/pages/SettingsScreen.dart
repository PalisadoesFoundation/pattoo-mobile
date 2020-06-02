import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pattoomobile/widgets/CustomSwitch.dart';
import 'package:pattoomobile/widgets/DarkModeSwitch.dart';
import 'package:pattoomobile/widgets/ShowFavSwitch.dart';
import 'package:pattoomobile/widgets/DropdownWidget.dart';

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
                child:Row(
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
                    width: 60.0,
                    height: 30.0,
                  ),
                    DropdownWidget(),
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
Widget SettingsContainer()
{
  return new Container(
    height: 500.0,
    color: Colors.transparent,
    child: new Container(
      margin: EdgeInsets.fromLTRB(20, 50, 20, 250),
        decoration: new BoxDecoration(
            color: Colors.white,
            borderRadius: new BorderRadius.only(
              topLeft: const Radius.circular(40.0),
              topRight: const Radius.circular(40.0),
              bottomLeft: const Radius.circular(40.0),
              bottomRight: const Radius.circular(40.0),

            ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
      ),

  );
}

