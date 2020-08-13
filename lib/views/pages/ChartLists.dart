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
        : FutureBuilder(
            future: getCharts(),
            builder: (context, snapshot) {
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
                    snapshot.connectionState == ConnectionState.waiting
                        ? SliverToBoxAdapter(
                            child: this.body,
                          )
                        : SliverGrid(
                            gridDelegate:
                                SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 200.0,
                              mainAxisSpacing: 10.0,
                              crossAxisSpacing: 10.0,
                            ),
                            delegate:
                                SliverChildBuilderDelegate((context, index) {
                              return Container(
                                width: 100,
                                child: Padding(
                                    padding: EdgeInsets.fromLTRB(
                                        10.0, 12.0, 10.0, 10.0),
                                    child: ButtonTheme(
                                      height: queryData.size.height * 0.04,
                                      minWidth: queryData.size.width * 0.1,
                                      child: RaisedButton(
                                          elevation: 5.0,
                                          shape: new RoundedRectangleBorder(
                                              borderRadius:
                                                  new BorderRadius.circular(
                                                      queryData.size
                                                              .shortestSide *
                                                          0.015)),
                                          color:
                                              Provider.of<ThemeManager>(context)
                                                  .themeData
                                                  .backgroundColor,
                                          onPressed: () {
                                            /* Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        MultiChart(snapshot
                                                            .data[index]))); */
                                          },
                                          child: new Center(
                                            child: Stack(
                                                fit: StackFit.passthrough,
                                                children: <Widget>[
                                                  Center(
                                                    child: Align(
                                                      alignment:
                                                          Alignment.topLeft,
                                                      child: SizedBox(
                                                        height: queryData
                                                                .size.height *
                                                            0.04,
                                                        width: queryData
                                                                .size.height *
                                                            0.04,
                                                        child: FittedBox(
                                                          fit: BoxFit.contain,
                                                          child: Stack(
                                                              children: <
                                                                  Widget>[
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
                                                        direction:
                                                            Axis.horizontal,
                                                        children: <Widget>[
                                                          Text(
                                                              "${snapshot.data[index].name}",
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: queryData.size.shortestSide * 0.05 >
                                                                              40 ||
                                                                          queryData.size.shortestSide * 0.05 <
                                                                              20
                                                                      ? 24
                                                                      : queryData
                                                                              .size
                                                                              .width *
                                                                          0.05,
                                                                  color: Colors
                                                                      .white),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center)
                                                        ]),
                                                  ),
                                                ]),
                                          )),
                                    )),
                              );
                            }, childCount: snapshot.data.length),
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
          uri: Provider.of<AgentsManager>(context, listen: false).httpLink),
    );
    QueryResult result = await _client.query(options);
    for (var json in result.data["allChart"]["edges"]) {
      if (json['node']['name'] != "") {
        Chart chart = Chart.fromJson(json);
        charts.add(chart);
      }
    }
    return charts;
  }
}
