import 'dart:core';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:pattoomobile/api/api.dart';
import 'package:pattoomobile/controllers/theme_manager.dart';
import 'package:pattoomobile/controllers/userState.dart';
import 'package:pattoomobile/views/pages/ChartScreen.dart';

import 'package:provider/provider.dart';
import 'package:pattoomobile/models/chart.dart';

//void main() => runApp(DataDisplay());

class DataDisplay extends StatefulWidget {
  DataDisplay() : super();
  @override
  _DataDisplayState createState() => _DataDisplayState();
}

class _DataDisplayState extends State<DataDisplay> {
  Widget build(BuildContext context) {
    final userState = Provider.of<UserState>(context);

    return Query(
        options: QueryOptions(
            documentNode: gql(AgentFetch().getFavoriteData),
            variables: {
              "username": userState.getUserName,
            }),
        // ignore: missing_return
        builder: (QueryResult result,
            {VoidCallback refetch, FetchMore fetchMore}) {
          if (result.hasException) {
            return Text(result.exception.toString());
          }

          if (result.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          var chart_data = result.data.data["allUser"]["edges"][0]["node"]
              ["favoriteUser"]["edges"];
          Map<int, Chart> charts = Map<int, Chart>();

          for (var node in chart_data) {
            int order = int.parse(node["node"]["order"]);

            if (node["node"]["chart"]["name"] != "" &&
                node["node"]["chart"]["enabled"] == "1") {
              Chart chart = Chart.fromJson(node["node"]["chart"], context);
              charts.addAll({order: chart});
            }
          }
          print(charts.length);
          MediaQueryData queryData = MediaQuery.of(context);
          return Scaffold(
            appBar: AppBar(
                leading: Container(),
                centerTitle: true,
                elevation: 20,
                title: Text("Favourite Charts",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold))),
            body: Column(children: <Widget>[
              SizedBox(
                height: queryData.size.longestSide * 0.05,
              ),
              Expanded(
                child: ReorderableListView(
                  children: List.generate(charts.length, (index) {
                    return InkWell(
                      key: UniqueKey(),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MultiChart(
                                    chart: charts.values.toList()[index])));
                      },
                      child: Align(
                        child: Container(
                          width: queryData.size.shortestSide * 0.85,
                          height: queryData.size.longestSide * 0.2,
                          child: Card(
                              elevation: 10.0,
                              margin: queryData.orientation ==
                                      Orientation.landscape
                                  ? EdgeInsets.only(
                                      top: queryData.size.longestSide * 0.017,
                                      bottom:
                                          queryData.size.longestSide * 0.017,
                                      left: queryData.size.shortestSide * 0.017,
                                      right:
                                          queryData.size.shortestSide * 0.017)
                                  : EdgeInsets.only(
                                      top: queryData.size.longestSide * 0.007,
                                      bottom:
                                          queryData.size.longestSide * 0.007,
                                      left: queryData.size.shortestSide * 0.017,
                                      right:
                                          queryData.size.shortestSide * 0.017),
                              shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(
                                      queryData.size.shortestSide * 0.015)),
                              color: Provider.of<ThemeManager>(context)
                                  .themeData
                                  .backgroundColor,
                              child: new Center(
                                child: Stack(
                                    fit: StackFit.passthrough,
                                    children: <Widget>[
                                      Center(
                                        child: Align(
                                          alignment: Alignment.topLeft,
                                          child: SizedBox(
                                            height:
                                                queryData.size.height * 0.04,
                                            width: queryData.size.height * 0.04,
                                            child: FittedBox(
                                              fit: BoxFit.contain,
                                              child: Stack(children: <Widget>[
                                                Icon(Icons.favorite,
                                                    color: Colors.red),
                                              ]),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Center(
                                        child: Wrap(
                                            direction: Axis.horizontal,
                                            children: <Widget>[
                                              Text(
                                                  "${charts.values.toList()[index].name}",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: queryData.size
                                                                          .shortestSide *
                                                                      0.05 >
                                                                  40 ||
                                                              queryData.size
                                                                          .shortestSide *
                                                                      0.05 <
                                                                  20
                                                          ? 24
                                                          : queryData
                                                                  .size.width *
                                                              0.05,
                                                      color: Colors.white),
                                                  textAlign: TextAlign.center)
                                            ]),
                                      ),
                                    ]),
                              )),
                        ),
                      ),
                    );
                  }),
                  onReorder: (int oldIndex, int newIndex) {
                    setState(() {
/*                   if (newIndex > oldIndex) {
                      newIndex -= 1;
                    }
                    final Chart newString = data.removeAt(oldIndex);
                    data.insert(newIndex, newString); */
                    });
                  },
                ),
              )
            ]),
          );
        });
  }
}
