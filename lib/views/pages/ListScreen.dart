import 'dart:async';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:pattoomobile/api/api.dart';
import 'package:pattoomobile/controllers/agent_controller.dart';
import 'package:pattoomobile/controllers/client_provider.dart';
import 'package:pattoomobile/controllers/theme_manager.dart';
import 'package:pattoomobile/models/agent.dart';
import 'package:pattoomobile/models/dataPointAgent.dart';
import 'package:pattoomobile/widgets/circleMenu.dart';
import 'package:provider/provider.dart';

class List extends StatefulWidget {
  Agent agent;
  @override
  List(this.agent);
  _ListState createState() => _ListState(agent);
}

class _ListState extends State<List> {
  Agent agent;
  _ListState(this.agent);
  String cursor = "";
  ScrollController _scrollController = new ScrollController();

  @override
  Widget build(BuildContext context) {
    this.agent.target_agents = [];
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    return ClientProvider(
      uri: Provider.of<AgentsManager>(context).loaded
          ? Provider.of<AgentsManager>(context).httpLink
          : "None",
      child: Scaffold(
        appBar: AppBar(
          title: Text('Reports(${agent.program})',
              style: TextStyle(color: Colors.white)),
          backgroundColor: Provider.of<ThemeManager>(context, listen: false)
              .themeData
              .backgroundColor,

        ),
        body: Query(
            options: QueryOptions(
              documentNode: gql(AgentFetch().getDataPointAgents),
              variables: <String, String>{
                "id": this.agent.id,
                "cursor": cursor
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

              if (result.data["allDatapoints"]["edges"].length == 0 &&
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
              for (var i in result.data["allDatapoints"]["edges"]) {
                DataPointAgent datapointagent = new DataPointAgent(
                    agent.id.toString(), i["node"]["idxDatapoint"]);
                for (var j in i["node"]["glueDatapoint"]["edges"]) {
                  if (j["node"]["pair"]["key"] == "pattoo_key") {
                    datapointagent.agent_struct.putIfAbsent(
                        "name",
                            () => {
                          "value": j["node"]["pair"]["value"],
                          "idxPair": j["node"]["idxPair"]
                        });
                    Provider.of<AgentsManager>(context, listen: false)
                        .getTranslatedName(
                        datapointagent.agent_struct["name"])
                        .then((val) => (datapointagent.agent_struct
                        .addAll({"name": val})));
                  } else {
                    datapointagent.agent_struct.putIfAbsent(
                        j["node"]["pair"]["key"],
                            () => {
                          "value": j["node"]["pair"]["value"],
                          "idxPair": j["node"]["idxPair"]
                        });
                  }
                  if (this.agent.target_agents.contains(datapointagent) ==
                      false) {
                    this.agent.addTarget(datapointagent);
                  }
                }
              }

              final Map pageInfo = result.data['allDatapoints']['pageInfo'];
              final String fetchMoreCursor = pageInfo['endCursor'];

              FetchMoreOptions opts = FetchMoreOptions(
                  variables: {'id': this.agent.id, 'cursor': fetchMoreCursor},
                  updateQuery: (previousResultData, fetchMoreResultData) {
                    // this is where you combine your previous data and response
                    // in this case, we want to display previous repos plus next repos
                    // so, we combine data in both into a single list of repos
                    for (var i in fetchMoreResultData.data["allDatapoints"]
                    ["edges"]) {
                      DataPointAgent datapointagent = new DataPointAgent(
                          agent.id.toString(), i["node"]["idxDatapoint"]);
                      for (var j in i["node"]["glueDatapoint"]["edges"]) {
                        if (j["node"]["pair"]["key"] == "pattoo_key") {
                          datapointagent.agent_struct.putIfAbsent(
                              "name",
                                  () => {
                                "value": j["node"]["pair"]["value"],
                                "idxPair": j["node"]["idxPair"]
                              });
                        } else {
                          datapointagent.agent_struct.putIfAbsent(
                              j["node"]["pair"]["key"],
                                  () => {
                                "value": j["node"]["pair"]["value"],
                                "idxPair": j["node"]["idxPair"]
                              });
                        }

                        if (this
                            .agent
                            .target_agents
                            .contains(datapointagent) ==
                            false) {
                          this.agent.addTarget(datapointagent);
                        }
                      }
                    }
                    ;
                  });

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
                  child: FutureBuilder<bool>(
                      future: wait(),
                      builder:
                          (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.done) {
                          return ListView.builder(
                            controller: _scrollController,
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: this.agent.target_agents.length,
                            itemBuilder: (context, index) {
                              return Card(
                                color: Provider.of<ThemeManager>(context)
                                    .themeData
                                    .buttonColor,
                                child: ListTile(
                                  title: Text(
                                    this
                                        .agent
                                        .target_agents[index]
                                        .agent_struct["name"],
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  leading: SizedBox(
                                      height: queryData.size.height * 0.09,
                                      width: queryData.size.width * 0.09,
                                      child: FittedBox(
                                          child: Image(
                                            image: AssetImage(
                                                'images/bar-chart.png'),
                                          ),
                                          fit: BoxFit.contain)),
                                  trailing: Icon(Icons.arrow_forward,
                                      color: Colors.white),
                                  onTap: () {},
                                ),
                              );
                            },
                          );
                        } else {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              CircularProgressIndicator(),
                            ],
                          );
                        }
                      }),
                )
              ]);
            }),
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
        ),),
    );
  }

  String parseDescriptions(Map map) {
    String result = "";
    for (MapEntry e in map.entries) {
      if (e.key != "name") {
        String res = "${e.key} : ${e.value} \n";
        result += res;
      }
    }
    return result;
  }

  Future<bool> wait() async {
    await new Future.delayed(const Duration(seconds: 2));
    return true;
  }
}
