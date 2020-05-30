import 'package:flutter/material.dart';
import 'package:pattoomobile/widgets/agents_option.dart';

class AgentsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Available Agents'),
      ),
      body: Center(
        child: Stack(
          children: <Widget>[
            showOptions(),
          ],
        ),
      ),

    );
  }
  Widget showOptions()
  {
    return new Container(
      padding: EdgeInsets.all(16.0),
      child: new ListView(
        shrinkWrap: true,
        children: <Widget>[
          MIB_SNMPButton(),
          AutonomousButton(),
          SNMPButton(),
        ],
      ),
    );
  }

}


