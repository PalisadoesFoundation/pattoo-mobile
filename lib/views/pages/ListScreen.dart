import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:pattoomobile/api/api.dart';
import 'package:pattoomobile/controllers/agent_controller.dart';
import 'package:pattoomobile/controllers/client_provider.dart';
import 'package:pattoomobile/controllers/theme_manager.dart';
import 'package:pattoomobile/models/agent.dart';
import 'package:pattoomobile/models/dataPointAgent.dart';
import 'package:pattoomobile/views/pages/DatapointChartScreen.dart';
import 'package:provider/provider.dart';

class List extends StatefulWidget {
  final Agent agent;
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
            ? Provider.of<AgentsManager>(context).httpLink + "/graphql"
            : "None",
        child: Scaffold(
          body: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                forceElevated: true,
                pinned: true,
                elevation: 10,
                expandedHeight: queryData.size.longestSide * 0.05,
                title: Text("Datapoint Agents",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    )),
              ),
              SliverToBoxAdapter(
                child: Query(
                    options: QueryOptions(
                      documentNode: gql(AgentFetch().getDataPointAgents),
                      variables: <String, String>{
                        "id": this.agent.id,
                        "cursor": cursor
                      },
                    ),
                    builder: (QueryResult result,
                        {refetch, FetchMore fetchMore}) {
                      if (result.loading && result.data == null) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      if (result.hasException) {
                        return Text(
                            '\nErrors: \n  ' + result.exception.toString());
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
                            var state = this.agent.translations[j["node"]
                                        ["pair"]["value"]] ==
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
                                        "value": this.agent.translations[
                                                j["node"]["pair"]["value"]]
                                            ["translation"],
                                        "unit": this.agent.translations[
                                            j["node"]["pair"]["value"]]["unit"]
                                      });
                            }
                          } else {
                            var state = this.agent.translations[j["node"]
                                        ["pair"]["key"]] ==
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
                                this
                                        .agent
                                        .translations[j["node"]["pair"]["key"]]
                                    ["translation"],
                                () => j["node"]["pair"]["value"],
                              );
                            }
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

                      final Map pageInfo =
                          result.data['allDatapoints']['pageInfo'];
                      final String fetchMoreCursor = pageInfo['endCursor'];

                      FetchMoreOptions opts = FetchMoreOptions(
                          variables: {
                            'id': this.agent.id,
                            'cursor': fetchMoreCursor
                          },
                          updateQuery:
                              (previousResultData, fetchMoreResultData) {
                            for (var i in fetchMoreResultData
                                .data["allDatapoints"]["edges"]) {
                              DataPointAgent datapointagent =
                                  new DataPointAgent(agent.id.toString(),
                                      i["node"]["idxDatapoint"]);
                              for (var j in i["node"]["glueDatapoint"]
                                  ["edges"]) {
                                if (j["node"]["pair"]["value"] ==
                                    "pattoo_key") {
                                  var state = this.agent.translations[j["node"]
                                              ["pair"]["value"]] ==
                                          null
                                      ? true
                                      : false;
                                  if (state) {
                                    datapointagent.agent_struct.putIfAbsent(
                                        "name",
                                        () => {
                                              "value": j["node"]["pair"]
                                                  ["value"],
                                              "unit": "None"
                                            });
                                  } else {
                                    datapointagent.agent_struct.putIfAbsent(
                                        "name",
                                        () => {
                                              "value": this.agent.translations[
                                                  j["node"]["pair"]
                                                      ["value"]]["translation"],
                                              "unit": this.agent.translations[
                                                  j["node"]["pair"]
                                                      ["value"]]["unit"]
                                            });
                                  }
                                } else {
                                  var state = this.agent.translations[j["node"]
                                              ["pair"]["key"]] ==
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
                                      this.agent.translations[j["node"]["pair"]
                                          ["key"]]["translation"],
                                      () => j["node"]["pair"]["value"],
                                    );
                                  }
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
                        // ignore: missing_return
                        queryData.orientation == Orientation.portrait
                            ? ListView(
                                controller: _scrollController,
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                children: <Widget>[
                                    for (var agent in this.agent.target_agents)
                                      InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      Chart(agent)));
                                        },
                                        child: Card(
                                            margin: EdgeInsets.only(
                                                top: queryData.size.longestSide *
                                                    0.01,
                                                bottom:
                                                    queryData.size.longestSide *
                                                        0.01,
                                                left: queryData.size.shortestSide *
                                                    0.045,
                                                right:
                                                    queryData.size.shortestSide *
                                                        0.045),
                                            elevation: 7.5,
                                            shape: new RoundedRectangleBorder(
                                                borderRadius:
                                                    new BorderRadius.circular(
                                                        queryData.size.shortestSide *
                                                            0.015)),
                                            color:
                                                Provider.of<ThemeManager>(context)
                                                    .themeData
                                                    .backgroundColor,
                                            child: new Center(
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: <Widget>[
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: <Widget>[
                                                      FittedBox(
                                                        fit: BoxFit.contain,
                                                        child: Image(
                                                          image: AssetImage(
                                                              'images/bar-chart.png'),
                                                          height: queryData
                                                                  .size.height *
                                                              0.14,
                                                          width: queryData
                                                                  .size.height *
                                                              0.14,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        SizedBox(
                                                          width: queryData
                                                                  .size.width *
                                                              0.47,
                                                          child: Text(
                                                              "\n" +
                                                                  agent.agent_struct[
                                                                          "name"]
                                                                      [
                                                                      "value"] +
                                                                  "\n" +
                                                                  information(
                                                                      agent) +
                                                                  "\n",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white)),
                                                        )
                                                      ]),
                                                ],
                                              ),
                                            )),
                                      ),
                                    SizedBox(
                                      height: queryData.size.height * 0.005,
                                    ),
                                    if (result.loading)
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          CircularProgressIndicator(),
                                        ],
                                      )
                                  ])
                            : GridView(
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2),
                                controller: _scrollController,
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                children: <Widget>[
                                    for (var agent in this.agent.target_agents)
                                      InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      Chart(agent)));
                                        },
                                        child: Align(
                                          child: Card(
                                              margin: EdgeInsets.only(
                                                  top: queryData.size.longestSide *
                                                      0.015,
                                                  bottom: queryData
                                                          .size.longestSide *
                                                      0.015,
                                                  left: queryData
                                                          .size.shortestSide *
                                                      0.015,
                                                  right:
                                                      queryData.size
                                                              .shortestSide *
                                                          0.015),
                                              elevation: 5.0,
                                              shape: new RoundedRectangleBorder(
                                                  borderRadius:
                                                      new BorderRadius.circular(
                                                          30.0)),
                                              color:
                                                  Provider.of<ThemeManager>(context)
                                                      .themeData
                                                      .backgroundColor,
                                              child: new Center(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: <Widget>[
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        FittedBox(
                                                          fit: BoxFit.contain,
                                                          child: Image(
                                                            image: AssetImage(
                                                                'images/bar-chart.png'),
                                                            height: queryData
                                                                    .size
                                                                    .longestSide *
                                                                0.24,
                                                            width: queryData
                                                                    .size
                                                                    .shortestSide *
                                                                0.24,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          SizedBox(
                                                            width: queryData
                                                                    .size
                                                                    .shortestSide *
                                                                0.47,
                                                            child: FittedBox(
                                                              fit: BoxFit
                                                                  .fitHeight,
                                                              child: Text(
                                                                  "\n" +
                                                                      agent.agent_struct[
                                                                              "name"]
                                                                          [
                                                                          "value"] +
                                                                      "\n" +
                                                                      information(
                                                                          agent) +
                                                                      "\n",
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                  )),
                                                            ),
                                                          )
                                                        ]),
                                                  ],
                                                ),
                                              )),
                                        ),
                                      ),
                                    SizedBox(
                                      height:
                                          queryData.size.longestSide * 0.005,
                                    ),
                                    if (result.loading)
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          CircularProgressIndicator(),
                                        ],
                                      )
                                  ])
                      ]);
                    }),
              )
            ],
          ),
        ));
  }

  String information(DataPointAgent agent) {
    var information = "\nDatapoint Agent ID : ${agent.datapoint_id}";
    for (MapEntry e in agent.agent_struct.entries) {
      if (e.key != "name") {
        information += "\n${e.key} : ${e.value}";
      }
    }
    return information;
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
}
