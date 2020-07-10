import 'dart:async';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:pattoomobile/api/api.dart';
import 'package:pattoomobile/controllers/agent_controller.dart';
import 'package:pattoomobile/controllers/client_provider.dart';
import 'package:pattoomobile/controllers/theme_manager.dart';
import 'package:pattoomobile/models/agent.dart';
import 'package:pattoomobile/models/dataPointAgent.dart';
import 'package:pattoomobile/views/pages/ChartScreen.dart';
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
          title: FittedBox(
            fit: BoxFit.fitWidth,
            child: Text('Reports(${agent.program})',
                style: TextStyle(color: Colors.white)),
          ),
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
                    var state =
                        this.agent.translations[j["node"]["pair"]["value"]] ==
                                null
                            ? true
                            : false;
                    if (state) {
                      datapointagent.agent_struct.putIfAbsent(
                          "name",
                          () => {
                                "value": j["node"]["pair"]["value"],
                                "unit": "None"
                              });
                    } else {
                      datapointagent.agent_struct.putIfAbsent(
                          "name",
                          () => {
                                "value": this.agent.translations[j["node"]
                                    ["pair"]["value"]]["translation"],
                                "unit": this.agent.translations[j["node"]
                                    ["pair"]["value"]]["unit"]
                              });
                    }
                  } else {
                    var state =
                        this.agent.translations[j["node"]["pair"]["key"]] ==
                                null
                            ? true
                            : false;
                    if (state) {
                      datapointagent.agent_struct.putIfAbsent(
                        j["node"]["pair"]["key"],
                        () => j["node"]["pair"]["value"],
                      );
                    } else {
                      datapointagent.agent_struct.putIfAbsent(
                        this.agent.translations[j["node"]["pair"]["key"]]
                            ["translation"],
                        () => j["node"]["pair"]["value"],
                      );
                    }
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
                        if (j["node"]["pair"]["value"] == "pattoo_key") {
                          var state = this.agent.translations[j["node"]["pair"]
                                      ["value"]] ==
                                  null
                              ? true
                              : false;
                          if (state) {
                            datapointagent.agent_struct.putIfAbsent(
                                "name",
                                () => {
                                      "value": j["node"]["pair"]["value"],
                                      "unit": "None"
                                    });
                          } else {
                            datapointagent.agent_struct.putIfAbsent(
                                "name",
                                () => {
                                      "value": this.agent.translations[j["node"]
                                          ["pair"]["value"]]["translation"],
                                      "unit": this.agent.translations[j["node"]
                                          ["pair"]["value"]]["unit"]
                                    });
                          }
                        } else {
                          var state = this
                                      .agent
                                      .translations[j["node"]["pair"]["key"]] ==
                                  null
                              ? true
                              : false;
                          if (state) {
                            datapointagent.agent_struct.putIfAbsent(
                              j["node"]["pair"]["key"],
                              () => j["node"]["pair"]["value"],
                            );
                          } else {
                            datapointagent.agent_struct.putIfAbsent(
                              this.agent.translations[j["node"]["pair"]["key"]]
                                  ["translation"],
                              () => j["node"]["pair"]["value"],
                            );
                          }
                        }
                        if (this.agent.target_agents.contains(datapointagent) ==
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
                  child: ListView(
                      controller: _scrollController,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      children: <Widget>[
                        for (var agent in this.agent.target_agents)
                          Card(
                            color: Provider.of<ThemeManager>(context)
                                .themeData
                                .buttonColor,
                            child: ListTile(
                              title: Text(
                                agent.agent_struct["name"]["value"],
                                style: TextStyle(color: Colors.white),
                              ),
                              subtitle: Text(
                                'sample',
                                style: TextStyle(color: Colors.white),
                              ),
                              leading: SizedBox(
                                  height: queryData.size.height * 0.09,
                                  width: queryData.size.width * 0.09,
                                  child: FittedBox(
                                      child: Image(
                                        image:
                                            AssetImage('images/bar-chart.png'),
                                      ),
                                      fit: BoxFit.contain)),
                              trailing: Icon(Icons.arrow_forward,
                                  color: Colors.white),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Chart(agent)));
                              },
                            ),
                          ),
                        if (result.loading)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              CircularProgressIndicator(),
                            ],
                          )
                      ]),
                )
              ]);
            }),
      ),
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
    await new Future.delayed(const Duration(seconds: 0));
    return true;
  }
}
