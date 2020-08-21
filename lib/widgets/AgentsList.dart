import 'package:flutter/material.dart';
import 'package:pattoomobile/widgets/AgentOptions.dart';
import 'package:pattoomobile/api/api.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'dart:convert';
import 'package:pattoomobile/models/agent.dart';
import 'package:provider/provider.dart';
import 'package:pattoomobile/controllers/agent_controller.dart';

import 'Display-Messages.dart';

class AgentsList extends StatelessWidget {
  Widget showOptions(BuildContext context) {
    ScrollController _scrollController = new ScrollController();
    MediaQueryData queryData = MediaQuery.of(context);
    return (Provider.of<AgentsManager>(context).loaded == false)
        ? DisplayMessage()
        : Column(children: [
            GridView(
                controller: _scrollController,
                scrollDirection: Axis.vertical,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount:
                        queryData.orientation == Orientation.portrait ? 2 : 3),
                shrinkWrap: true,
                children: <Widget>[
                  for (var agent
                      in Provider.of<AgentsManager>(context).agentsList)
                    agentButton(context, agent),
                ])
          ]);
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          forceElevated: true,
          leading: Container(),
          pinned: true,
          title: Text("Pattoo Agents",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              )),
          centerTitle: true,
        ),
        SliverToBoxAdapter(
          child: showOptions(context),
        )
      ],
    );
  }

  String getPrettyJSONString(Object jsonObject) {
    return const JsonEncoder.withIndent('  ').convert(jsonObject);
  }
}
