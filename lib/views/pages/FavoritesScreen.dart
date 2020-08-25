import 'dart:collection';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:pattoomobile/api/api.dart';
import 'package:pattoomobile/controllers/agent_controller.dart';
import 'package:pattoomobile/controllers/theme_manager.dart';
import 'package:pattoomobile/controllers/userState.dart';
import 'package:pattoomobile/views/pages/ChartScreen.dart';
import 'package:pattoomobile/widgets/Display-Messages.dart';

import 'package:provider/provider.dart';
import 'package:reorderables/reorderables.dart';

//void main() => runApp(DataDisplay());

class DataDisplay extends StatefulWidget {
  DataDisplay() : super();
  @override
  _DataDisplayState createState() => _DataDisplayState();
}

class _DataDisplayState extends State<DataDisplay> {
  Widget build(BuildContext context) {
    final userState = Provider.of<UserState>(context);
    setState(() {});
    MediaQueryData queryData = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
          leading: Container(),
          centerTitle: true,
          elevation: 20,
          title: Text("Favourite Charts",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
      body: (Provider.of<AgentsManager>(context).loaded == false)
          ? DisplayMessage()
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                  SizedBox(
                    height: queryData.size.longestSide * 0.05,
                  ),
                  Expanded(
                    child: StatefulBuilder(builder: (context, updateState) {
                      return ReorderableWrap(
                        direction: Axis.horizontal,
                        padding: const EdgeInsets.all(8),
                        children: List<Widget>.generate(
                            userState.chartsList.length, (index) {
                          return InkWell(
                            key: UniqueKey(),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MultiChart(
                                          chart: userState.chartsList[index]
                                              ["chart"])));
                            },
                            child: Align(
                              child: Container(
                                height: queryData.size.longestSide * 0.2,
                                child: Card(
                                    elevation: 10.0,
                                    margin: queryData.orientation ==
                                            Orientation.landscape
                                        ? EdgeInsets.only(
                                            top: queryData.size.longestSide *
                                                0.017,
                                            bottom: queryData.size.longestSide *
                                                0.017,
                                            left: queryData.size.shortestSide *
                                                0.017,
                                            right: queryData.size.shortestSide *
                                                0.017)
                                        : EdgeInsets.only(
                                            top: queryData.size.longestSide *
                                                0.007,
                                            bottom: queryData.size.longestSide *
                                                0.007,
                                            left: queryData.size.shortestSide *
                                                0.017,
                                            right: queryData.size.shortestSide *
                                                0.017),
                                    shape: new RoundedRectangleBorder(
                                        borderRadius: new BorderRadius.circular(
                                            queryData.size.shortestSide *
                                                0.015)),
                                    color: Provider.of<ThemeManager>(context).themeData.backgroundColor,
                                    child: new Center(
                                      child: Stack(
                                          fit: StackFit.passthrough,
                                          children: <Widget>[
                                            Center(
                                              child: Align(
                                                alignment: Alignment.topLeft,
                                                child: SizedBox(
                                                    height:
                                                        queryData.size.height *
                                                            0.04,
                                                    width:
                                                        queryData.size.height *
                                                            0.04,
                                                    child: Icon(
                                                      Icons.favorite,
                                                      color: Colors.red,
                                                    )),
                                              ),
                                            ),
                                            Center(
                                              child: Wrap(
                                                  direction: Axis.horizontal,
                                                  children: <Widget>[
                                                    Text(
                                                        userState
                                                            .chartsList[index]
                                                                ["chart"]
                                                            .name,
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: queryData.size.shortestSide *
                                                                            0.05 >
                                                                        40 ||
                                                                    queryData.size.shortestSide *
                                                                            0.05 <
                                                                        20
                                                                ? 24
                                                                : queryData.size
                                                                        .width *
                                                                    0.05,
                                                            color:
                                                                Colors.white),
                                                        textAlign:
                                                            TextAlign.center)
                                                  ]),
                                            ),
                                          ]),
                                    )),
                              ),
                            ),
                          );
                        }),
                        onReorder: (int oldIndex, int newIndex) {
                          updateState(() {
                            if (newIndex > oldIndex) {
                              newIndex -= 1;
                            }
                            var oldChart =
                                userState.chartsList.elementAt(newIndex);
                            var newChart =
                                userState.chartsList.removeAt(oldIndex);
                            userState.chartsList.insert(newIndex, newChart);
                            List update = List();

                            update.add({
                              "chart": newChart["idFavorite"],
                              "order": newIndex
                            });
                            update.add({
                              "chart": oldChart["idFavorite"],
                              "order": oldIndex
                            });
                            updateOrder(update).then((value) => {});
                          });
                        },
                      );
                    }),
                  )
                ]),
    );
  }

  Future updateOrder(List charts) async {
    print(charts);
    List results = List();
    for (var chart in charts) {
      QueryOptions options = QueryOptions(
        documentNode: gql(AgentFetch().updateFavouriteOrder),
        variables: <String, String>{
          "order": chart["order"].toString(),
          "idxFavorite": chart["chart"]
        },
      );
      print(Provider.of<AgentsManager>(context, listen: false).httpLink +
          "/graphql");
      GraphQLClient _client = GraphQLClient(
        cache: InMemoryCache(),
        link: new HttpLink(
            uri: Provider.of<AgentsManager>(context, listen: false).httpLink +
                "/graphql"),
      );
      QueryResult result = await _client.query(options);
      results.add(result.data);
    }
    await Provider.of<UserState>(context, listen: false)
        .loadFavourites(context);
    return results;
  }
}
