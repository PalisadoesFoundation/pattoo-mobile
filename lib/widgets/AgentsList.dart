import 'package:flutter/material.dart';
import 'package:pattoomobile/widgets/AgentOptions.dart';
import 'package:pattoomobile/api/api.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pattoomobile/models/datapoint.dart';
import 'package:pattoomobile/models/dataPointAgent.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:pattoomobile/models/agent.dart';
import 'package:provider/provider.dart';
import 'package:pattoomobile/controllers/theme_manager.dart';
import 'package:pattoomobile/controllers/agent_controller.dart';

class AgentsList extends StatelessWidget {
  Widget showOptions(BuildContext context) {

    Provider.of<AgentsManager>(context).agents = [];
    
    ScrollController _scrollController = new ScrollController();

    return Query(
        options: QueryOptions(
          documentNode: gql(AgentFetch().getAllAgents),
          variables: <String, String>{
            // set cursor to null so as to start at the beginning
            // 'cursor': 10
          },
        ),
        builder: (QueryResult result, {refetch, FetchMore fetchMore}) {
          if (result.loading && result.data == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (result.hasException) {
            return Text('\nErrors: \n  ' + result.exception.toString());
          }

          if (result.data["allAgentXlate"]["edges"].length == 0 &&
              result.exception == null) {
            return Column(
              children: <Widget>[
                SizedBox(
                  height: 250,
                ),
                Text('No Agents available',
                    style: Theme.of(context).textTheme.headline6),
                SizedBox(
                  height: 20,
                ),
                Container(
                    height: 200,
                    child: Image.asset(
                      'images/waiting.png',
                      fit: BoxFit.cover,
                    )),
              ],
            );
          }

          for (var i in result.data["allAgentXlate"]["edges"]) {
            Agent agent =
                new Agent(i["node"]["idxAgentXlate"], i["node"]["translation"]);
            Provider.of<AgentsManager>(context, listen: false)
                .agents
                .add(agent);
          }
          final Map pageInfo = result.data['allAgentXlate']['pageInfo'];
          final String fetchMoreCursor = pageInfo['endCursor'];

          FetchMoreOptions opts = FetchMoreOptions(
            variables: {'cursor': fetchMoreCursor},
            updateQuery: (previousResultData, fetchMoreResultData) {
              // this is where you combine your previous data and response
              // in this case, we want to display previous repos plus next repos
              // so, we combine data in both into a single list of repos
              for (var i in fetchMoreResultData["allAgentXlate"]["edges"]) {
                Agent agent = new Agent(
                    i["node"]["idxAgentXlate"], i["node"]["translation"]);
                Provider.of<AgentsManager>(context, listen: false)
                    .agents
                    .add(agent);
              }
            },
          );

          _scrollController
            ..addListener(() {
              if (_scrollController.position.pixels ==
                  _scrollController.position.maxScrollExtent) {
                if (!result.loading) {
                  fetchMore(opts);
                }
              }
            });

          return Column(children: [
            Expanded(
              child: ListView.builder(
                  controller: _scrollController,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount:
                      Provider.of<AgentsManager>(context).agentsList.length,
                  itemBuilder: (context, index) {
                    if (result.loading) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          CircularProgressIndicator(),
                        ],
                      );
                    }
                    return agentButton(context,
                        Provider.of<AgentsManager>(context).agentsList[index]);
                  }),
            )
          ]);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Available Agents'),
        backgroundColor:
            Provider.of<ThemeManager>(context).themeData.backgroundColor,
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
