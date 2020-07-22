import 'dart:async';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:pattoomobile/api/api.dart';
import 'package:pattoomobile/controllers/agent_controller.dart';
import 'package:pattoomobile/controllers/client_provider.dart';
import 'package:pattoomobile/controllers/theme_manager.dart';
import 'package:pattoomobile/models/agent.dart';
import 'package:pattoomobile/models/dataPointAgent.dart';
import 'package:pattoomobile/models/view_models/user.dart';
import 'package:pattoomobile/views/pages/ChartScreen.dart';
import 'package:provider/provider.dart';


class FavList extends StatefulWidget {
  Agent agent;
  User user;
  @override
  _FavListState createState() => _FavListState(user);
}

class _FavListState extends State<FavList> {
  Agent agent;
  User user;

  _FavListState(this.user);

  String cursor = "";
  ScrollController _scrollController = new ScrollController();

  @override
  Widget build(BuildContext context) {
    this.user.fav_agents = [];
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    return ClientProvider(
      uri: Provider
          .of<AgentsManager>(context)
          .loaded
          ? Provider
          .of<AgentsManager>(context)
          .httpLink
          : "None",
      child: Scaffold(
        appBar: AppBar(
          title: FittedBox(
            fit: BoxFit.fitWidth,
            child: Text('Favorite Reports of(${user.username})',
                style: TextStyle(color: Colors.white)),
          ),
          backgroundColor: Provider
              .of<ThemeManager>(context, listen: false)
              .themeData
              .backgroundColor,
        ),
        body: Query(
            options: QueryOptions(
              documentNode: gql(AgentFetch().getFavoriteData),
              variables: <String, String>{
                "id": this.user.username,
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
              if (result.data["getFavoriteData"]["edges"].length == 0 &&
                  result.exception == null) {
                return Column(
                  children: <Widget>[
                    SizedBox(
                      height: 250,
                    ),
                    Text('No Agents available',
                        style: Theme
                            .of(context)
                            .textTheme
                            .headline6),
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

              for (var i in result.data["getFavoriteData"]["edges"]) {
                User usera = new User(
                    agent.id.toString(), i["node"]["idxDatapoint"]);
                for (var j in i["node"]["glueDatapoint"]["edges"]) {
                  if (j["node"]["pair"]["key"] == "pattoo_key") {
                    var state =
                    this.agent.translations[j["node"]["pair"]["value"]] ==
                        null
                        ? true
                        : false;
                    if (state) {
                      usera.agent_struct.putIfAbsent(
                          "name",
                              () =>
                          {
                            "value": j["node"]["pair"]["value"],
                            "unit": "None"
                          });
                    } else {
                      usera.agent_struct.putIfAbsent(
                          "name",
                              () =>
                          {
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
                      usera.agent_struct.putIfAbsent(
                        j["node"]["pair"]["key"],
                            () => j["node"]["pair"]["value"],
                      );
                    } else {
                      usera.agent_struct.putIfAbsent(
                        this.agent.translations[j["node"]["pair"]["key"]]
                        ["translation"],
                            () => j["node"]["pair"]["value"],
                      );
                    }
                  }
                }
              }
              final Map pageInfo = result.data['getFavoriteData'];


              return Column(children: [
                Expanded(
                  child: ListView(
                      controller: _scrollController,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      children: <Widget>[
                        for (var agent in this.agent.target_agents)
                          Card(
                            color: Provider
                                .of<ThemeManager>(context)
                                .themeData
                                .buttonColor,
                            child: ListTile(
                              title: Text(
                                agent.agent_struct["name"]["value"],
                                style: TextStyle(color: Colors.white),
                              ),
                              subtitle: Text(
                                'unique identifier',
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
}