import 'package:flutter/material.dart';
import 'package:pattoomobile/widgets/AgentOptions.dart';
import 'package:pattoomobile/api/api.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'dart:convert';
import 'package:pattoomobile/models/agent.dart';
import 'package:provider/provider.dart';
import 'package:pattoomobile/controllers/theme_manager.dart';
import 'package:pattoomobile/controllers/agent_controller.dart';
import 'package:pattoomobile/widgets/circleMenu.dart';

import 'Display-Messages.dart';
class AgentsList extends StatelessWidget {
  Widget showOptions(BuildContext context) {
    Map translationMap = new Map();
    ScrollController _scrollController = new ScrollController();
    print("Loaded = ");
    print(Provider.of<AgentsManager>(context).loaded);
    return (Provider.of<AgentsManager>(context).loaded == false) ? DisplayMessage() : Query(
        options: QueryOptions(
          documentNode: gql(AgentFetch().translateAgent),
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
          for (var i in result.data["allAgentXlate"]["edges"]) {
            translationMap.putIfAbsent(
                i["node"]["agentProgram"], () => i["node"]["translation"]);
          }
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

                if (result.data["allAgent"]["edges"].length == 0 &&
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
                Provider.of<AgentsManager>(context).agents = new List();;

                for (var i in result.data['allAgent']['edges']){
                      Agent agent = new Agent(i["node"]["idxAgent"],
                          translationMap[i["node"]["agentProgram"]]);
                      Provider.of<AgentsManager>(context, listen: false)
                          .agents
                          .add(agent);
                    }
                final Map pageInfo = result.data['allAgent']['pageInfo'];
                final String fetchMoreCursor = pageInfo['endCursor'];

                FetchMoreOptions opts = FetchMoreOptions(
                  variables: {'cursor': fetchMoreCursor},
                  updateQuery: (previousResultData, fetchMoreResultData) {
                    // this is where you combine your previous data and response
                    // in this case, we want to display previous repos plus next repos
                    // so, we combine data in both into a single list of repos
                    for (var i in fetchMoreResultData["allAgent"]["edges"]){
                      Agent agent = new Agent(i["node"]["idxAgent"],
                          translationMap[i["node"]["agentProgram"]]);
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
                      child: GridView(
                          controller: _scrollController,
                          scrollDirection: Axis.vertical,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2),
                          shrinkWrap: true,
                          children: <Widget>[
                        for (var agent
                            in Provider.of<AgentsManager>(context).agentsList)
                          agentButton(context, agent),
                        if (result.loading)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              CircularProgressIndicator(),
                            ],
                          )
                      ]))
                ]);
              });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Available Agents',style: TextStyle(color:Colors.white)),
        backgroundColor:
            Provider.of<ThemeManager>(context).themeData.backgroundColor,
            actions: <Widget>[Menu()],
      ),
      body: Center(
        child: Stack(
          children: <Widget>[
            showOptions(context),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0, // this will be set when a new tab is tapped
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.home),
            title: new Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.favorite),
            title: new Text('Favorites'),
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              title: Text('Settings')
          )
        ],
      ),
    );
  }

  String getPrettyJSONString(Object jsonObject) {
    return const JsonEncoder.withIndent('  ').convert(jsonObject);
  }
}
