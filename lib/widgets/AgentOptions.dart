import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pattoomobile/controllers/theme_manager.dart';
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

  Widget agentButton(BuildContext context, agentName) {
    return new Padding(
      padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
      child: RaisedButton(
        elevation: 5.0,
        shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(30.0)),
        color: Provider.of<ThemeManager>(context).themeData.backgroundColor,
        onPressed: () {
          Navigator.pushNamed(context, '/Listscreen');
        },        
        child: new Text(agentName,
        style: TextStyle(fontSize: 20, color: Colors.white)),
      ),
    );
  }

