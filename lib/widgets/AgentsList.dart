import 'package:flutter/material.dart';
import 'package:pattoomobile/widgets/AgentOptions.dart';
import 'package:provider/provider.dart';
import 'package:pattoomobile/controllers/theme_manager.dart';
class AgentsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Available Agents'),
        backgroundColor: Provider.of<ThemeManager>(context).themeData.backgroundColor,
      ),
      body: Center(
        child: Stack(
          children: <Widget>[
            showOptions(context),
          ],
        ),
      ),

    );
  }
  
  Widget showOptions(BuildContext context)
  {
    return new Container(
      padding: EdgeInsets.all(16.0),
      child: new ListView(
        shrinkWrap: true,
        children: <Widget>[
          MIB_SNMPButton(context),
          AutonomousButton(context),
          SNMPButton(context),
        ],
      ),
    );
  }

}


