import 'package:flutter/material.dart';
import 'package:pattoomobile/controllers/theme_manager.dart';
import 'package:provider/provider.dart';
import 'package:pattoomobile/views/pages/ListScreen.dart';
Widget agentButton(BuildContext context, agent) {
  return new Padding(
    padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
    child: RaisedButton(
      elevation: 5.0,
      shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(30.0)),
      color: Provider.of<ThemeManager>(context).themeData.backgroundColor,
      onPressed: () {
          Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => List(agent),
          ),
        );
      },
      child: new Text(agent.program,
          style: TextStyle(fontSize: 20, color: Colors.white),
          textAlign: TextAlign.center),
    ),
  );
}

class agentoption extends StatefulWidget {
  @override
  _agentoptionState createState() => _agentoptionState();
}

class _agentoptionState extends State<agentoption> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
