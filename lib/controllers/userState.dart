import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:pattoomobile/api/api.dart';
import 'package:pattoomobile/controllers/agent_controller.dart';
import 'package:pattoomobile/models/chart.dart';
import 'package:provider/provider.dart';

class UserState with ChangeNotifier {
  String _userName = "";
  var charts;
  List favCharts = List();
  List chartsList = List();
  String idxUser;
  void setDisplayName(String text) {
    this._userName = text;
    print("User logged in is ${this._userName}");
  }

  String get getUserName => _userName;

  Future loadFavourites(BuildContext context) async {
    QueryOptions options = QueryOptions(
        documentNode: gql(AgentFetch().getFavoriteData),
        variables: {
          "username": this._userName,
        });
    GraphQLClient _client = GraphQLClient(
      cache: InMemoryCache(),
      link: new HttpLink(
          uri: Provider.of<AgentsManager>(context, listen: false).httpLink +
              "/graphql"),
    );
    QueryResult result = await _client.query(options);
    this.idxUser = result.data["allUser"]["edges"][0]["node"]["idxUser"];

    // ignore: missing_return

    var chart_data =
        result.data["allUser"]["edges"][0]["node"]["favoriteUser"]["edges"];
    SplayTreeMap<int, Map> charts = SplayTreeMap<int, Map>();

    for (var node in chart_data) {
      int order = int.parse(node["node"]["order"]);
      String idxFavourite = node["node"]["idxFavorite"];
      //Checks if chart is enabled. If its equal to 1, it is enabled and displayed on the screen, and vice versa
      if (node["node"]["chart"]["name"] != "" &&
          node["node"]["chart"]["enabled"] == "1" &&
          node["node"]["enabled"] == "1") {
        Chart chart = Chart.fromJson(node["node"]["chart"], context);
        Map map = {"chart": chart, "idFavorite": idxFavourite};
        charts.addAll({order: map});
      }
    }
    this.charts = charts;
    this.charts.forEach((k, v) => !this.favCharts.contains(v["chart"])
        ? this.favCharts.add(v["chart"])
        : null);

    this.chartsList = charts.values.toList();
  }
}
