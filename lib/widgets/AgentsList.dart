import 'package:flutter/material.dart';
import 'package:pattoomobile/widgets/AgentOptions.dart';
import 'package:pattoomobile/api/api.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'dart:convert';
import 'package:pattoomobile/models/agent.dart';
import 'package:provider/provider.dart';
import 'package:pattoomobile/controllers/theme_manager.dart';
import 'package:pattoomobile/controllers/agent_controller.dart';

class AgentsList extends StatelessWidget {
  Widget showOptions(BuildContext context)
  {
      return Container(
      padding: EdgeInsets.all(16.0),
      child: new ListView(
        shrinkWrap: true,
        children: <Widget>[
          for(var i in Provider.of<AgentsManager>(context).agentsList) agentButton(context, i.program),
        ],
      ),
    );
        }
  

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

  String getPrettyJSONString(Object jsonObject) {
  return const JsonEncoder.withIndent('  ').convert(jsonObject);
}
}


