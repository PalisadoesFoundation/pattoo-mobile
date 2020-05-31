import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pattoomobile/widgets/CustomSwitch.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
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
          ],
        ),
      ),

    );
  }
}

Widget SettingsContainer()
{
  return new Container(
    height: 500.0,
    color: Colors.transparent,
    child: new Container(
      margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
        decoration: new BoxDecoration(
            color: Colors.blue[50],
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

        child: new Center(

          child:ListView.builder(

            itemCount: 10,
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                  title: Text('Dark Mode'),
                  trailing: MyApp(),
                  onTap: () {},
                ),
              );
            },
          ),
        ),

    ),

  );
}

