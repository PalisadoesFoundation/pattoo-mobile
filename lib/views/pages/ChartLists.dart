import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:pattoomobile/api/api.dart';
import 'package:pattoomobile/controllers/agent_controller.dart';
import 'package:pattoomobile/controllers/theme_manager.dart';
import 'package:pattoomobile/models/chart.dart';
import 'package:provider/provider.dart';
import 'package:pattoomobile/widgets/Display-Messages.dart';

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
              pinned: true,
              expandedHeight: queryData.size.height * 0.25,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  'Charts',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 24),
                ),
                centerTitle: true,

                //fillColor: Colors.green

                background: Stack(fit: StackFit.expand, children: <Widget>[
                  Lottie.asset('assets/chart.json', fit: BoxFit.fill),
                  Center(
                      heightFactor: 1,
                      child: Text(
                        'Pattoo',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 42),
                      )),
                ]),
              ),
            ),
            SliverToBoxAdapter(child: DisplayMessage())
          ])
        : FutureBuilder(
            future: getCharts(),
            builder: (context, snapshot) {
              return snapshot.connectionState == ConnectionState.waiting
                  ? this.body
                  : CustomScrollView(
                      slivers: <Widget>[
                        SliverAppBar(
                          pinned: true,
                          expandedHeight: queryData.size.height * 0.25,
                          flexibleSpace: FlexibleSpaceBar(
                            title: Text(
                              'Charts',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 24),
                            ),
                            centerTitle: true,

                            //fillColor: Colors.green

                            background:
                                Stack(fit: StackFit.expand, children: <Widget>[
                              Lottie.asset('assets/chart.json',
                                  fit: BoxFit.fill),
                              Center(
                                  heightFactor: 1,
                                  child: Text(
                                    'Pattoo',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize: 42),
                                  )),
                            ]),
                          ),
                        ),
                        SliverGrid(
                          gridDelegate:
                              SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 200.0,
                            mainAxisSpacing: 10.0,
                            crossAxisSpacing: 10.0,
                          ),
                          delegate:
                              SliverChildBuilderDelegate((context, index) {
/*                         RandomColor _randomColor = RandomColor();
                        List<dynamic> colors = List<dynamic>.generate(
                            snapshot.data.length,
                            (index) => _randomColor
                                .randomColor(colorHue: ColorHue.blue)
                                .value);
                        List<dynamic> compColors = colors
                            .map((x) => int.parse(
                                CalculateComplimentaryColor.fromHex(
                                        HexColor(x.toRadixString(16)))
                                    .toString(),
                                radix: 16))
                            .toList();
                        double scale = 1.0; */
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
                                                    30.0)),
                                        color:
                                            Provider.of<ThemeManager>(context)
                                                .themeData
                                                .backgroundColor,
                                        onPressed: () {},
                                        child: new Center(
                                          child: Stack(
                                              fit: StackFit.passthrough,
                                              children: <Widget>[
                                                Center(
                                                  child: SizedBox(
                                                    height:
                                                        queryData.size.height *
                                                            0.14,
                                                    width:
                                                        queryData.size.height *
                                                            0.14,
                                                    child: FittedBox(
                                                      fit: BoxFit.contain,
                                                      child: Stack(
                                                          children: <Widget>[
                                                            Opacity(
                                                              opacity: 0.6,
                                                              child: Image(
                                                                  image: AssetImage(
                                                                      assetName)),
                                                            ),
                                                          ]),
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
                                                                fontSize: queryData.size.width *
                                                                                0.05 >
                                                                            40 ||
                                                                        queryData.size.width *
                                                                                0.05 <
                                                                            20
                                                                    ? 24
                                                                    : queryData
                                                                            .size
                                                                            .width *
                                                                        0.05,
                                                                color: Colors
                                                                    .white),
                                                            textAlign: TextAlign
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
