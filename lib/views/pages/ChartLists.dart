import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:pattoomobile/api/api.dart';
import 'package:pattoomobile/controllers/agent_controller.dart';
import 'package:pattoomobile/controllers/theme_manager.dart';
import 'package:pattoomobile/models/chart.dart';
import 'package:provider/provider.dart';
import 'package:pattoomobile/widgets/Display-Messages.dart';
import 'package:pattoomobile/views/pages/ChartScreen.dart';

class ChartList extends StatefulWidget {
  ChartList({Key key}) : super(key: key);

  @override
  _ChartListState createState() => _ChartListState();
}

class _ChartListState extends State<ChartList> {
  List<Chart> charts = new List<Chart>();
  Widget body = Center(child: CircularProgressIndicator());
  bool chartsLoaded = false;
  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData = MediaQuery.of(context);
    String assetName = "assets/increase.png";
    return (Provider.of<AgentsManager>(context).loaded == false)
        ? CustomScrollView(slivers: <Widget>[
            SliverAppBar(
              forceElevated: true,
              leading: Container(),
              pinned: true,
              title: Text(
                'Charts',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              centerTitle: true,
            ),
            SliverToBoxAdapter(child: DisplayMessage())
          ])
        : Query(
            options: QueryOptions(
              documentNode: gql(AgentFetch().getAllCharts),
            ),
            builder: (QueryResult result, {refetch, FetchMore fetchMore}) {
              List<Chart> charts = new List<Chart>();
              if (result.loading && result.data == null) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (result.hasException) {
                return Text('\nErrors: \n  ' + result.exception.toString());
              }
              for (var json in result.data["allChart"]["edges"]) {
                if (json['node']['name'] != "") {
                  Chart chart = Chart.fromJson(json['node'], context);
                  charts.add(chart);
                }
              }
              return Scaffold(
                body: CustomScrollView(
                  slivers: <Widget>[
                    SliverAppBar(
                        forceElevated: true,
                        pinned: true,
                        leading: Container(),
                        centerTitle: true,
                        title: Text(
                          'Pattoo Charts',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        )),
                    SliverGrid(
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 200.0,
                        mainAxisSpacing: 10.0,
                        crossAxisSpacing: 10.0,
                      ),
                      delegate: SliverChildBuilderDelegate((context, index) {
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        MultiChart(chart: charts[index])));
                          },
                          child: Align(
                            child: Container(
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
                                                height: queryData.size.height *
                                                    0.04,
                                                width: queryData.size.height *
                                                    0.04,
                                                child: FittedBox(
                                                  fit: BoxFit.contain,
                                                  child:
                                                      Stack(children: <Widget>[
                                                    Image(
                                                        image: AssetImage(
                                                            assetName)),
                                                  ]),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Center(
                                            child: Wrap(
                                                direction: Axis.horizontal,
                                                children: <Widget>[
                                                  Text("${charts[index].name}",
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
                                                              : queryData.size
                                                                      .width *
                                                                  0.05,
                                                          color: Colors.white),
                                                      textAlign:
                                                          TextAlign.center)
                                                ]),
                                          ),
                                        ]),
                                  )),
                            ),
                          ),
                        );
                      }, childCount: charts.length),
                    ),
                  ],
                ),
              );
            });
  }

  Future<List<Chart>> getCharts() async {
    List<Chart> charts = new List<Chart>();
    QueryOptions options = QueryOptions(
      documentNode: gql(AgentFetch().getAllCharts),
    );
    GraphQLClient _client = GraphQLClient(
      cache: InMemoryCache(),
      link: new HttpLink(
          uri: Provider.of<AgentsManager>(context, listen: false).httpLink +
              "/graphql"),
    );
    QueryResult result = await _client.query(options);
    for (var json in result.data["allChart"]["edges"]) {
      if (json['node']['name'] != "") {
        Chart chart = Chart.fromJson(json['node'], context);
        charts.add(chart);
      }
    }
    return charts;
  }
}
