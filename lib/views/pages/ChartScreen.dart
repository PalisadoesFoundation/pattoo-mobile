/* import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' hide TextStyle, Axis;
import 'package:flutter/services.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:pattoomobile/api/api.dart';
import 'package:pattoomobile/controllers/agent_controller.dart';
import 'package:pattoomobile/controllers/client_provider.dart';
import 'package:pattoomobile/controllers/theme_manager.dart';
import 'package:pattoomobile/models/agent.dart';
import 'package:pattoomobile/models/chart.dart';
import 'package:pattoomobile/models/dataPointAgent.dart';
import 'package:pattoomobile/models/timestamp.dart';
import 'package:pattoomobile/models/view_models/user.dart';
import 'package:pattoomobile/views/pages/ChartLists.dart';
import 'package:pattoomobile/views/pages/FullScreenChart.dart';
import 'package:pattoomobile/widgets/MetaDataTile.dart';
import 'package:pattoomobile/widgets/SampleChart.dart';
import 'package:pattoomobile/widgets/createChartGroupPopUp.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:pattoomobile/models/chart.dart';
import 'package:pattoomobile/widgets/userData.dart';

class MultiChart extends StatelessWidget {
  final Chart chart;
  MultiChart(this.chart);
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    final HttpLink httpLink =
        HttpLink(uri: "http://calico.palisadoes.org/pattoo/api/v1/web/graphql");
    final ValueNotifier<GraphQLClient> client = ValueNotifier<GraphQLClient>(
      GraphQLClient(
        link: httpLink,
        cache: OptimisticCache(
          dataIdFromObject: typenameDataIdFromObject,
        ),
      ),
    );

    return GraphQLProvider(
      child: MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: ChartScreen(
            title: agent.agent_struct["name"]["value"], agent: this.agent),
      ),
      client: client,
    );
  }
}

final String addFavourite = """
      mutation {
      createFavorite(Input: {idxUser: \$idxUser, idxChart:  \$a, order: \$b }) {
        favorite {
          id
          idxFavorite
          idxChart
          idxUser
          enabled
        }
      }
    }
""";

class MultiChartScreen extends StatefulWidget {
  MultiChartScreen({Key key, this.title, DataPointAgent this.agent})
      : super(key: key);
  final DataPointAgent agent;
  final String title;

  @override
  _MultiChartScreenState createState() => _MultiChartScreenState(chart);
}

class _MultiChartScreenState extends State<MultiChartScreen> {
  Chart chart;
  List<DataPointAgent> original_agents = List<DataPointAgent>();
  List<DataPointAgent> agents = List<DataPointAgent>();

  _MultiChartScreenState(this.chart);
  List<TimeSeriesSales> data_;
  List<TimeSeriesSales> cdata_;
  var fav_color = Colors.grey[100];
  bool favourite = false;
  Widget chart_;
  final List<bool> isSelected = [false, false, true];
  List<Series<TimeSeriesSales, DateTime>> vibrationData =
      List<Series<TimeSeriesSales, DateTime>>();

  final idxuser = User.idxUser.toString();

  final a = "3";
  final b = "4";

  @override
  Widget build(BuildContext context) {
    Widget saveButton = Padding(
        padding: EdgeInsets.all(10.0),
        child: RaisedButton(
          color: Colors.green,
          child: Text("SAVE",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          onPressed: (() {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return ChartGroupPopUp(
                    context: context,
                    agents: agents,
                  );
                });
          }),
        ));
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    if (!this.agents.contains(agent)) {
      this.agents.add(agent);
    }
    //Chart chart= new Chart();
    //User user = new User();

    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[agents.length > 1 ? saveButton : Container()],
        title: FittedBox(
          fit: BoxFit.fitWidth,
          child: Text(
            chart.name,
          ),
        ),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
      ),
      body: Mutation(
        options: MutationOptions(
          documentNode: gql(addFavourite),
          onCompleted: (dynamic resultData) {
            print(a);
            print(b);
            print(idxuser);
            print(resultData);
          },
        ),
        builder: (RunMutation insert, QueryResult result) {
          return Container(
            padding: EdgeInsets.all(8.0),
            color: Colors.grey[100],
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Container(
                      color: Colors.white,
                      width: queryData.size.width * 1,
                      height: queryData.size.width * 0.8,
                      child: Column(
                        children: <Widget>[
                          FutureBuilder(
                              future: this.fetchTimeSeries(agents),
                              builder:
                                  // ignore: missing_return
                                  (BuildContext context,
                                      AsyncSnapshot snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Expanded(
                                    child: Center(
                                        child: Container(
                                      height: queryData.size.height * 0.35,
                                      width: queryData.size.width * 0.8,
                                      child: Center(
                                          child: CircularProgressIndicator()),
                                    )),
                                  );
                                } else if (snapshot.hasData &&
                                    snapshot.connectionState ==
                                        ConnectionState.done) {
                                  for (var result in snapshot.data) {
                                    vibrationData.add(
                                        new Series<TimeSeriesSales, DateTime>(
                                      id: agents[snapshot.data.indexOf(result)]
                                          .agent_struct['name']['value'],
                                      domainFn: (TimeSeriesSales sales, _) =>
                                          sales.time,
                                      measureFn: (TimeSeriesSales sales, _) =>
                                          sales.sales,
                                      data: result,
                                    ));
                                  }

                                  this.chart = queryData.orientation ==
                                          Orientation.landscape
                                      ? Hero(
                                          tag: "chart",
                                          child: TimeSeriesChart(vibrationData,
                                              behaviors: [
                                                SeriesLegend(
                                                    entryTextStyle:
                                                        TextStyleSpec(
                                                            fontSize: 12),
                                                    position:
                                                        BehaviorPosition.bottom,
                                                    horizontalFirst: true,
                                                    desiredMaxRows: 3,
                                                    desiredMaxColumns: 2),
                                                LinePointHighlighter(
                                                  drawFollowLinesAcrossChart:
                                                      true,
                                                  showHorizontalFollowLine:
                                                      LinePointHighlighterFollowLineType
                                                          .all,
                                                ),
                                              ],
                                              defaultRenderer:
                                                  LineRendererConfig(),
                                              animate: true,
                                              domainAxis: DateTimeAxisSpec(
                                                  renderSpec:
                                                      SmallTickRendererSpec(
                                                          labelRotation: 45),
                                                  tickFormatterSpec:
                                                      AutoDateTimeTickFormatterSpec(
                                                          day: TimeFormatterSpec(
                                                              format: 'dd/MM',
                                                              transitionFormat:
                                                                  'yyyy')))))
                                      : Hero(
                                          tag: "chart",
                                          child: TimeSeriesChart(vibrationData,
                                              behaviors: [
                                                LinePointHighlighter(
                                                  drawFollowLinesAcrossChart:
                                                      true,
                                                  showHorizontalFollowLine:
                                                      LinePointHighlighterFollowLineType
                                                          .all,
                                                ),
                                              ],
                                              defaultRenderer:
                                                  LineRendererConfig(),
                                              animate: true,
                                              domainAxis: DateTimeAxisSpec(
                                                  renderSpec:
                                                      SmallTickRendererSpec(
                                                          labelRotation: 45),
                                                  tickFormatterSpec:
                                                      AutoDateTimeTickFormatterSpec(
                                                          day: TimeFormatterSpec(
                                                              format: 'dd/MM',
                                                              transitionFormat:
                                                                  'yyyy')))));

                                  return Expanded(
                                    child: Center(
                                        child: Container(
                                      height: queryData.size.height * 0.75,
                                      width: queryData.size.width * 0.8,
                                      child: vibrationData != null
                                          ? chart
                                          : CircularProgressIndicator(),
                                    )),
                                  );
                                }
                              }),
                          Container(
                              child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Wrap(direction: Axis.horizontal, children: <
                                  Widget>[
                                FloatingActionButton(
                                  backgroundColor:
                                      agents.length >= 7 ? Colors.grey : null,
                                  heroTag: null,
                                  child: Icon(Icons.filter_9_plus),
                                  onPressed: agents.length >= 7
                                      ? () {}
                                      : () {
                                          _addChart(context);
                                        },
                                ),
                                SizedBox(width: queryData.size.width * 0.03),
                                FloatingActionButton(
                                  heroTag: null,
                                  child: Icon(Icons.favorite, color: fav_color),
                                  onPressed: () {
                                    insert({
                                      'idxUser': idxuser,
                                      'idxChart': a,
                                      'order': b,
                                    });
                                  },
                                ),
                                SizedBox(width: queryData.size.width * 0.03),
                                FloatingActionButton(
                                  heroTag: null,
                                  child: Icon(
                                    Icons.zoom_out_map,
                                  ),
                                  onPressed: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (_) {
                                      return FullScreenChart(
                                        child: chart,
                                      );
                                    }));
                                  },
                                ),
                              ])
                            ],
                          )),
                          SizedBox(height: queryData.size.height * 0.03),
                          Container(
                            child:
                                LayoutBuilder(builder: (context, constraints) {
                              return ToggleButtons(
                                renderBorder: false,
                                constraints: BoxConstraints.expand(
                                    height: constraints.maxHeight * 0.5,
                                    width: constraints.maxWidth * 0.325),
                                borderRadius: BorderRadius.circular(5),
                                children: <Widget>[
                                  Text("1D",
                                      style: TextStyle(
                                          fontSize:
                                              queryData.size.width * 0.036 > 24
                                                  ? 18
                                                  : queryData.size.width *
                                                      0.036,
                                          fontWeight: FontWeight.bold)),
                                  Text("1M",
                                      style: TextStyle(
                                          fontSize:
                                              queryData.size.width * 0.036 > 24
                                                  ? 18
                                                  : queryData.size.width *
                                                      0.036,
                                          fontWeight: FontWeight.bold)),
                                  Text("1Y",
                                      style: TextStyle(
                                          fontSize:
                                              queryData.size.width * 0.036 > 24
                                                  ? 18
                                                  : queryData.size.width *
                                                      0.036,
                                          fontWeight: FontWeight.bold)),
                                ],
                                onPressed: (int index) {
                                  int count = 0;
                                  isSelected.forEach((bool val) {
                                    if (val) count++;
                                  });

                                  if (isSelected[index] && count < 2) return;

                                  setState(() {
                                    isSelected[index] = !isSelected[index];
                                  });
                                },
                                isSelected: isSelected,
                              );
                            }),
                          ),
                          SizedBox(height: queryData.size.height * 0.01)
                        ],
                      ),
                    ),
                    SizedBox(height: queryData.size.height * 0.035),
                    Container(
                      color: Colors.white,
                      width: queryData.size.width * 0.9,
                      child: StatefulBuilder(builder: (context, fixState) {
                        fixState(() {});
                        return Column(
                          children: ListTile.divideTiles(
                            context: context,
                            tiles: [
                              ListTile(title: Text("MetaData")),
                              for (MapEntry e
                                  in this.agent.agent_struct.entries)
                                if (e.key == "name" &&
                                    e.value["unit"] != "None")
                                  MetaDataTile(
                                    title: "Unit of Measurment",
                                    value: e.value["unit"],
                                  ),
                              for (MapEntry e
                                  in this.agent.agent_struct.entries)
                                if (e.key != "name")
                                  MetaDataTile(
                                    title: e.key,
                                    value: e.value,
                                  ),
                              if (this.agents.asMap().containsKey(1))
                                for (var agent in this.agents.sublist(1))
                                  for (Widget tile
                                      in loadSecondAgentData(agent))
                                    tile
                            ],
                          ).toList(),
                        );
                      }),
                    )
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }

  List loadSecondAgentData(DataPointAgent agent) {
    List<dynamic> lst = List.filled(
        1,
        ListTile(
          title: Text(agent.agent_struct["name"]["value"]),
          trailing: IconButton(
            icon: Icon(
              Icons.remove_circle,
              color: Colors.red,
            ),
            onPressed: (() {
              setState(() {
                agents.remove(agent);
              });
            }),
          ),
        ),
        growable: true);
    for (MapEntry e in agent.agent_struct.entries) {
      if (e.key == "name" && e.value["unit"] != "None")
        lst.add(MetaDataTile(
          title: "Unit of Measurment",
          value: e.value["unit"],
        ));
      else if (e.key != "name") {
        lst.add(MetaDataTile(
          title: e.key,
          value: e.value,
        ));
      }
    }
    return lst;
  }

  _addChart(BuildContext context) async {
    var obj = Provider.of<AgentsManager>(context, listen: false).agents;
    var agents = obj.map((val) => val.program).toList();
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    String dropdownVal;
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, updateState) {
            return OrientationBuilder(
                // ignore: missing_return
                builder: (BuildContext context, Orientation orientation) {
              switch (orientation) {
                case Orientation.portrait:
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    title: Text('Add Chart'),
                    content: Container(
                        height: queryData.size.height * 0.8,
                        width: queryData.size.width * 0.8,
                        child: Column(children: <Widget>[
                          DropdownButton<dynamic>(
                            value: dropdownVal,
                            items: agents
                                .map((value) => DropdownMenuItem<dynamic>(
                                      child: SizedBox(
                                        width: queryData.size.width * 0.6,
                                        child: FittedBox(
                                            fit: BoxFit.fitWidth,
                                            child: Text(value)),
                                      ),
                                      value: value,
                                    ))
                                .toList(),
                            onChanged: (newvalue) {
                              updateState(() {
                                dropdownVal = newvalue;
                              });
                            },
                            isExpanded: true,
                            icon: Icon(Icons.assignment),
                            iconEnabledColor: Provider.of<ThemeManager>(context)
                                .themeData
                                .backgroundColor,
                            hint: Text('Select Agent'),
                          ),
                          SizedBox(height: queryData.size.height * 0.1),
                          Container(
                              height: queryData.size.height * 0.5,
                              child: Expanded(
                                child: ListView(children: <Widget>[
                                  dropdownVal == null
                                      ? Container()
                                      : SizedBox(
                                          height: queryData.size.height * 1,
                                          child: getList(context,
                                              obj[agents.indexOf(dropdownVal)]))
                                ]),
                              ))
                        ])),
                    actions: <Widget>[
                      FlatButton(
                        child: Text('CANCEL'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      )
                    ],
                  );
                case Orientation.landscape:
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    title: Text('Add Chart'),
                    content: Container(
                        height: queryData.size.height * 0.8,
                        width: queryData.size.width * 0.8,
                        child: Column(children: <Widget>[
                          DropdownButton<dynamic>(
                            value: dropdownVal,
                            items: agents
                                .map((value) => DropdownMenuItem<dynamic>(
                                      child: SizedBox(
                                          width: queryData.size.width * 0.6,
                                          child: FittedBox(
                                            fit: BoxFit.scaleDown,
                                            child: Text(value),
                                          )),
                                      value: value,
                                    ))
                                .toList(),
                            onChanged: (newvalue) {
                              updateState(() {
                                dropdownVal = newvalue;
                              });
                            },
                            isExpanded: true,
                            icon: Icon(Icons.assignment),
                            iconEnabledColor: Provider.of<ThemeManager>(context)
                                .themeData
                                .backgroundColor,
                            hint: Text('Select Agent'),
                          ),
                          Container(
                              height: queryData.size.height * 0.32,
                              child: Expanded(
                                child: ListView(children: <Widget>[
                                  dropdownVal == null
                                      ? Container()
                                      : SizedBox(
                                          height: queryData.size.height * 1,
                                          child: getList(context,
                                              obj[agents.indexOf(dropdownVal)]))
                                ]),
                              ))
                        ])),
                    actions: <Widget>[
                      FlatButton(
                        child: Text('CANCEL'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      )
                    ],
                  );
              }
            });
          });
        });
  }

  Future<Widget> removeAgentConfirmation(
      BuildContext context, DataPointAgent agent) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text("Agent Removal Confirmation")),
            content: Container(
              child: Center(
                child: Text(
                    "Are you sure you want to remove Agent ${agent.agent_struct['name']['value']}"),
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text("YES"),
                onPressed: (() {
                  this.setState(() {
                    print(agent);
                    print(this.agents);
                    this.agents.remove(agent);
                    print(this.agents);
                  });
                  Navigator.of(context).pop();
                }),
              ),
              FlatButton(
                child: Text("NO"),
                onPressed: (() {
                  Navigator.of(context).pop();
                }),
              ),
            ],
          );
        });
  }

  Widget getList(BuildContext context, Agent agent) {
    agent.target_agents = [];
    MediaQueryData queryData;
    String cursor = "";
    ScrollController _scrollController = new ScrollController();
    queryData = MediaQuery.of(context);
    return ClientProvider(
      uri: Provider.of<AgentsManager>(context).loaded
          ? Provider.of<AgentsManager>(context).httpLink
          : "None",
      child: Query(
          options: QueryOptions(
            documentNode: gql(AgentFetch().getDataPointAgents),
            variables: <String, String>{"id": agent.id, "cursor": cursor},
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
                      agent.translations[j["node"]["pair"]["value"]] == null
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
                              "value":
                                  agent.translations[j["node"]["pair"]["value"]]
                                      ["translation"],
                              "unit":
                                  agent.translations[j["node"]["pair"]["value"]]
                                      ["unit"]
                            });
                  }
                } else {
                  var state =
                      agent.translations[j["node"]["pair"]["key"]] == null
                          ? true
                          : false;
                  if (state) {
                    datapointagent.agent_struct.putIfAbsent(
                      j["node"]["pair"]["key"],
                      () => j["node"]["pair"]["value"],
                    );
                  } else {
                    datapointagent.agent_struct.putIfAbsent(
                      agent.translations[j["node"]["pair"]["key"]]
                          ["translation"],
                      () => j["node"]["pair"]["value"],
                    );
                  }
                }
                if (agent.target_agents.contains(datapointagent) == false) {
                  agent.addTarget(datapointagent);
                }
              }
            }
            final Map pageInfo = result.data['allDatapoints']['pageInfo'];
            final String fetchMoreCursor = pageInfo['endCursor'];

            FetchMoreOptions opts = FetchMoreOptions(
                variables: {'id': agent.id, 'cursor': fetchMoreCursor},
                updateQuery: (previousResultData, fetchMoreResultData) {
                  for (var i in fetchMoreResultData.data["allDatapoints"]
                      ["edges"]) {
                    DataPointAgent datapointagent = new DataPointAgent(
                        agent.id.toString(), i["node"]["idxDatapoint"]);
                    for (var j in i["node"]["glueDatapoint"]["edges"]) {
                      if (j["node"]["pair"]["value"] == "pattoo_key") {
                        var state =
                            agent.translations[j["node"]["pair"]["value"]] ==
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
                                    "value": agent.translations[j["node"]
                                        ["pair"]["value"]]["translation"],
                                    "unit": agent.translations[j["node"]["pair"]
                                        ["value"]]["unit"]
                                  });
                        }
                      } else {
                        var state =
                            agent.translations[j["node"]["pair"]["key"]] == null
                                ? true
                                : false;
                        if (state) {
                          datapointagent.agent_struct.putIfAbsent(
                            j["node"]["pair"]["key"],
                            () => j["node"]["pair"]["value"],
                          );
                        } else {
                          datapointagent.agent_struct.putIfAbsent(
                            agent.translations[j["node"]["pair"]["key"]]
                                ["translation"],
                            () => j["node"]["pair"]["value"],
                          );
                        }
                      }
                      if (agent.target_agents.contains(datapointagent) ==
                          false) {
                        agent.addTarget(datapointagent);
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

            return Column(
              children: [
                Expanded(
                  child: ListView(
                      controller: _scrollController,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      children: <Widget>[
                        for (var agent in agent.target_agents)
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
                                "Datapoint Agent ID: ${agent.datapoint_id}",
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
                                setState(() {
                                  if (!this.agents.contains(agent)) {
                                    this.agents.add(agent);
                                  }

                                  Navigator.pop(context);
                                });
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
              ],
            );
          }),
    );
  }

  String information(DataPointAgent agent) {
    var information = "ID : ${agent.datapoint_id}";
    for (MapEntry e in agent.agent_struct.entries) {
      if (e.key != "name") {
        information += "\n${e.key} : ${e.value}";
      }
    }
    return information;
  }

  List<TimeSeriesSales> parseProducts(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

    List<TimeSeriesSales> data = [];
    for (var i in parsed) {
      if (i["value"] != null) {
        TimeStamp date = new TimeStamp(
            value: i["value"].round(), timestamp: (i["timestamp"]));
        data.add(TimeSeriesSales(date.Timestamp, date.value));
      }
    }
    return data;
  }

  fetchTimeSeries(List datapoints) async {
    var client = new http.Client();
    List data_ = new List();
    this.agents = datapoints;
    print(agents);
    this.vibrationData = List<Series<TimeSeriesSales, DateTime>>();
    for (DataPointAgent agent in datapoints) {
      try {
        var result = await client.get(
            'http://calico.palisadoes.org/pattoo/api/v1/web/rest/data/${agent.datapoint_id}');

        if (result.statusCode == 200) {
          data_.add(parseProducts(result.body));
        } else {
          throw Exception('Unable to fetch TimeSeries Data from the REST API');
        }
      } finally {}
    }
    client.close();
    print(data_.length.toString() + " Bout this big");
    return data_;
  }

  void changeView(int view) {
    Map views = {1: 12, 2: 288, 3: 8760, 4: 52560, 5: 525601};
    if (this.data_.length >= views[view]) {
      this.cdata_ = this
          .data_
          .where((x) => this.data_.indexOf(x) % views[view] == 0)
          .toList();

      Map format = {1: "h", 2: "dd/mm", 3: "M", 4: "M", 5: "Y"};
      setState(() {
        this.vibrationData = [
          Series<TimeSeriesSales, DateTime>(
            id: 'Sales',
            colorFn: (_, __) => MaterialPalette.blue.shadeDefault,
            domainFn: (TimeSeriesSales sales, _) => sales.time,
            measureFn: (TimeSeriesSales sales, _) => sales.sales,
            data: this.cdata_,
          )
        ];
        this.chart_ = TimeSeriesChart(vibrationData,
            defaultRenderer:
                LineRendererConfig(includeArea: true, stacked: true),
            animate: true,
            domainAxis: DateTimeAxisSpec(
                tickFormatterSpec: AutoDateTimeTickFormatterSpec(
                    day: TimeFormatterSpec(
                        format: format[view], transitionFormat: 'yyyy '))));
      });
    }
  }
}
 */

import 'dart:convert';

import 'package:charts_flutter/flutter.dart' hide TextStyle, Axis;
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:pattoomobile/api/api.dart';
import 'package:pattoomobile/controllers/agent_controller.dart';
import 'package:pattoomobile/controllers/client_provider.dart';
import 'package:pattoomobile/controllers/theme_manager.dart';
import 'package:pattoomobile/controllers/userState.dart';
import 'package:pattoomobile/models/agent.dart';
import 'package:pattoomobile/models/chart.dart';
import 'package:pattoomobile/models/dataPointAgent.dart';
import 'package:pattoomobile/models/timestamp.dart';
import 'package:pattoomobile/utils/app_themes.dart';
import 'package:pattoomobile/views/pages/FullScreenChart.dart';
import 'package:pattoomobile/widgets/MetaDataTile.dart';
import 'package:pattoomobile/widgets/SampleChart.dart';
import 'package:pattoomobile/widgets/createChartGroupPopUp.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class MultiChart extends StatefulWidget {
  final Chart chart;

  MultiChart({Key key, @required this.chart}) : super(key: key);

  @override
  _MultiChartState createState() => _MultiChartState(chart: chart);
}

class _MultiChartState extends State<MultiChart> {
  final Chart chart;
  _MultiChartState({@required this.chart});
  List<DataPointAgent> original_agents = List<DataPointAgent>();
  List<DataPointAgent> agents = List<DataPointAgent>();
  List<TimeSeriesSales> data_;
  List<TimeSeriesSales> cdata_;

  Widget chart_data;
  final Map<String, int> timeframe = {
    "yy": 31536000,
    'mm': 2628288,
    "dd": 86400
  };
  final List<bool> isSelected = [false, true, false];
  int current_Timeframe;
  List<Series<TimeSeriesSales, DateTime>> vibrationData =
      List<Series<TimeSeriesSales, DateTime>>();

  @override
  Widget build(BuildContext context) {
    bool favourite = Provider.of<UserState>(context, listen: false)
        .favCharts
        .contains(this.chart);
    var fav_color = favourite ? Colors.red : Colors.grey[100];
    Widget saveButton = Padding(
        padding: EdgeInsets.all(10.0),
        child: RaisedButton(
          color: Colors.green,
          child: Text("SAVE",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          onPressed: (() {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return ChartGroupPopUp(
                    context: context,
                    agents: agents,
                  );
                });
          }),
        ));
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);

    original_agents = chart.datapoints.values.toList();
    agents = chart.datapoints.values.toList();
    print(agents);
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[Container()],
        title: FittedBox(
            fit: BoxFit.fitWidth,
            child: Text(chart.name,
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold))),
        elevation: 0.0,
      ),
      body: Container(
        padding: EdgeInsets.all(8.0),
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                      color: Provider.of<ThemeManager>(context, listen: false)
                                  .localTheme ==
                              AppTheme.Light
                          ? Colors.white
                          : Colors.grey[300],
                      borderRadius: BorderRadius.circular(
                          queryData.size.shortestSide * 0.015)),
                  width: queryData.size.width * 1,
                  height: queryData.size.longestSide * 0.75,
                  child: Column(
                    children: <Widget>[
                      FutureBuilder(
                          future:
                              this.fetchTimeSeries(agents, current_Timeframe),
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Expanded(
                                child: Center(
                                    child: Container(
                                  height: queryData.size.height * 0.35,
                                  width: queryData.size.width * 0.8,
                                  child: Center(
                                      child: CircularProgressIndicator()),
                                )),
                              );
                            } else if (snapshot.hasData &&
                                snapshot.connectionState ==
                                    ConnectionState.done) {
                              for (var result in snapshot.data) {
                                vibrationData
                                    .add(new Series<TimeSeriesSales, DateTime>(
                                  id: agents[snapshot.data.indexOf(result)]
                                      .agent_struct['name']['value'],
                                  domainFn: (TimeSeriesSales sales, _) =>
                                      sales.time,
                                  measureFn: (TimeSeriesSales sales, _) =>
                                      sales.sales,
                                  data: result,
                                ));
                              }

                              this.chart_data = queryData.orientation ==
                                      Orientation.landscape
                                  ? Hero(
                                      tag: "chart",
                                      child: TimeSeriesChart(vibrationData,
                                          behaviors: [
                                            SeriesLegend(
                                                entryTextStyle:
                                                    TextStyleSpec(fontSize: 12),
                                                position:
                                                    BehaviorPosition.bottom,
                                                horizontalFirst: true,
                                                desiredMaxRows: 3,
                                                desiredMaxColumns: 2),
                                            LinePointHighlighter(
                                              drawFollowLinesAcrossChart: true,
                                              showHorizontalFollowLine:
                                                  LinePointHighlighterFollowLineType
                                                      .all,
                                            ),
                                          ],
                                          defaultRenderer: LineRendererConfig(),
                                          animate: true,
                                          domainAxis: DateTimeAxisSpec(
                                              renderSpec: SmallTickRendererSpec(
                                                  labelRotation: 45),
                                              tickFormatterSpec:
                                                  AutoDateTimeTickFormatterSpec(
                                                      day: TimeFormatterSpec(
                                                          format: 'dd/MM',
                                                          transitionFormat:
                                                              'yyyy')))))
                                  : Hero(
                                      tag: "chart",
                                      child: TimeSeriesChart(vibrationData,
                                          behaviors: [
                                            LinePointHighlighter(
                                              drawFollowLinesAcrossChart: true,
                                              showHorizontalFollowLine:
                                                  LinePointHighlighterFollowLineType
                                                      .all,
                                            ),
                                          ],
                                          defaultRenderer: LineRendererConfig(),
                                          animate: true,
                                          domainAxis: DateTimeAxisSpec(
                                              renderSpec: SmallTickRendererSpec(
                                                  labelRotation: 45),
                                              tickFormatterSpec:
                                                  AutoDateTimeTickFormatterSpec(
                                                      day: TimeFormatterSpec(
                                                          format: 'dd/MM',
                                                          transitionFormat:
                                                              'yyyy')))));

                              return Expanded(
                                child: Center(
                                    child: Container(
                                  height: queryData.size.height * 0.75,
                                  width: queryData.size.width * 0.8,
                                  child: vibrationData != null
                                      ? chart_data
                                      : CircularProgressIndicator(),
                                )),
                              );
                            }
                          }),
                      SizedBox(height: queryData.size.longestSide * 0.03),
                      Container(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Wrap(direction: Axis.horizontal, children: <Widget>[
                            FloatingActionButton(
                              backgroundColor:
                                  agents.length >= 7 ? Colors.grey : null,
                              heroTag: null,
                              child: Icon(Icons.filter_9_plus),
                              onPressed: agents.length >= 7
                                  ? () {}
                                  : () {
                                      _addChart(context);
                                    },
                            ),
                            SizedBox(width: queryData.size.width * 0.03),
                            FloatingActionButton(
                                heroTag: null,
                                child: Icon(Icons.favorite, color: fav_color),
                                onPressed: () {
                                  setState(() {
                                    !favourite
                                        ? this.addFavourite().then((val) {})
                                        : this.removeFavourite().then((val) {});
                                  });
                                }),
                            SizedBox(width: queryData.size.width * 0.03),
                            FloatingActionButton(
                              heroTag: null,
                              child: Icon(
                                Icons.zoom_out_map,
                              ),
                              onPressed: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (_) {
                                  return FullScreenChart(
                                    child: chart_data,
                                  );
                                }));
                              },
                            ),
                          ])
                        ],
                      )),
                      SizedBox(height: queryData.size.height * 0.03),
                      Container(
                        child: LayoutBuilder(builder: (context, constraints) {
                          return ToggleButtons(
                            fillColor: Provider.of<ThemeManager>(context)
                                .themeData
                                .accentColor,
                            renderBorder: false,
                            constraints: BoxConstraints.expand(
                                height: constraints.maxHeight * 0.5,
                                width: constraints.maxWidth * 0.325),
                            borderRadius: BorderRadius.circular(5),
                            children: <Widget>[
                              Text("1D",
                                  style: TextStyle(
                                      color: isSelected[0]
                                          ? Colors.white
                                          : Colors.black,
                                      fontSize:
                                          queryData.size.width * 0.036 > 24
                                              ? 18
                                              : queryData.size.width * 0.036,
                                      fontWeight: FontWeight.bold)),
                              Text("1M",
                                  style: TextStyle(
                                      color: isSelected[1]
                                          ? Colors.white
                                          : Colors.black,
                                      fontSize:
                                          queryData.size.width * 0.036 > 24
                                              ? 18
                                              : queryData.size.width * 0.036,
                                      fontWeight: FontWeight.bold)),
                              Text("1Y",
                                  style: TextStyle(
                                      color: isSelected[2]
                                          ? Colors.white
                                          : Colors.black,
                                      fontSize:
                                          queryData.size.width * 0.036 > 24
                                              ? 18
                                              : queryData.size.width * 0.036,
                                      fontWeight: FontWeight.bold)),
                            ],
                            onPressed: (int index) {
                              for (int i = 0; i < isSelected.length; i++) {
                                isSelected[i] = i == index;
                              }
                              switch (isSelected.indexOf(true)) {
                                case 0:
                                  current_Timeframe = timeframe["dd"];
                                  break;
                                case 1:
                                  current_Timeframe = timeframe["mm"];
                                  break;
                                case 2:
                                  current_Timeframe = timeframe["yy"];
                                  break;
                              }
                              setState(() {});
                            },
                            isSelected: isSelected,
                          );
                        }),
                      ),
                      SizedBox(height: queryData.size.height * 0.01)
                    ],
                  ),
                ),
                SizedBox(height: queryData.size.height * 0.035),
                Container(
                  decoration: BoxDecoration(
                      color: Provider.of<ThemeManager>(context)
                          .themeData
                          .cardColor,
                      borderRadius: BorderRadius.circular(
                          queryData.size.shortestSide * 0.015)),
                  width: queryData.size.width,
                  child: StatefulBuilder(builder: (context, fixState) {
                    fixState(() {});
                    return Column(
                      children: ListTile.divideTiles(
                        context: context,
                        tiles: [
                          ListTile(
                              title: Text("MetaData",
                                  style: TextStyle(
                                      color: Provider.of<ThemeManager>(context)
                                          .themeData
                                          .textTheme
                                          .headline5
                                          .color,
                                      fontWeight: FontWeight.bold))),
                          for (var agent in this.agents)
                            for (Widget tile in loadAgentData(agent)) tile
                        ],
                      ).toList(),
                    );
                  }),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  List loadAgentData(DataPointAgent agent) {
    List<dynamic> lst = List.filled(
        1,
        ListTile(
          title: Text(agent.agent_struct["name"]["value"]),
        ),
        growable: true);
    for (MapEntry e in agent.agent_struct.entries) {
      if (e.key == "name" && e.value["unit"] != "None")
        lst.add(MetaDataTile(
          title: "Unit of Measurment",
          value: e.value["unit"],
        ));
      else if (e.key != "name") {
        lst.add(MetaDataTile(
          title: e.key,
          value: e.value,
        ));
      }
    }
    return lst;
  }

  _addChart(BuildContext context) async {
    var obj = Provider.of<AgentsManager>(context, listen: false).agents;
    var agents = obj.map((val) => val.program).toList();
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    String dropdownVal;
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, updateState) {
            return OrientationBuilder(
                builder: (BuildContext context, Orientation orientation) {
              switch (orientation) {
                case Orientation.portrait:
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    title: Text('Add Chart'),
                    content: Container(
                        height: queryData.size.height * 0.8,
                        width: queryData.size.width * 0.8,
                        child: Column(children: <Widget>[
                          DropdownButton<dynamic>(
                            value: dropdownVal,
                            items: agents
                                .map((value) => DropdownMenuItem<dynamic>(
                                      child: SizedBox(
                                        width: queryData.size.width * 0.6,
                                        child: FittedBox(
                                            fit: BoxFit.fitWidth,
                                            child: Text(value)),
                                      ),
                                      value: value,
                                    ))
                                .toList(),
                            onChanged: (newvalue) {
                              updateState(() {
                                dropdownVal = newvalue;
                              });
                            },
                            isExpanded: true,
                            icon: Icon(Icons.assignment),
                            iconEnabledColor: Provider.of<ThemeManager>(context)
                                .themeData
                                .backgroundColor,
                            hint: Text('Select Agent'),
                          ),
                          SizedBox(height: queryData.size.height * 0.1),
                          Container(
                              height: queryData.size.height * 0.5,
                              child: Expanded(
                                child: ListView(children: <Widget>[
                                  dropdownVal == null
                                      ? Container()
                                      : SizedBox(
                                          height: queryData.size.height * 1,
                                          child: getList(context,
                                              obj[agents.indexOf(dropdownVal)]))
                                ]),
                              ))
                        ])),
                    actions: <Widget>[
                      FlatButton(
                        child: Text('CANCEL'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      )
                    ],
                  );
                case Orientation.landscape:
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    title: Text('Add Chart'),
                    content: Container(
                        height: queryData.size.height * 0.8,
                        width: queryData.size.width * 0.8,
                        child: Column(children: <Widget>[
                          DropdownButton<dynamic>(
                            value: dropdownVal,
                            items: agents
                                .map((value) => DropdownMenuItem<dynamic>(
                                      child: SizedBox(
                                          width: queryData.size.width * 0.6,
                                          child: FittedBox(
                                            fit: BoxFit.scaleDown,
                                            child: Text(value),
                                          )),
                                      value: value,
                                    ))
                                .toList(),
                            onChanged: (newvalue) {
                              updateState(() {
                                dropdownVal = newvalue;
                              });
                            },
                            isExpanded: true,
                            icon: Icon(Icons.assignment),
                            iconEnabledColor: Provider.of<ThemeManager>(context)
                                .themeData
                                .backgroundColor,
                            hint: Text('Select Agent'),
                          ),
                          Container(
                              height: queryData.size.height * 0.32,
                              child: Expanded(
                                child: ListView(children: <Widget>[
                                  dropdownVal == null
                                      ? Container()
                                      : SizedBox(
                                          height: queryData.size.height * 1,
                                          child: getList(context,
                                              obj[agents.indexOf(dropdownVal)]))
                                ]),
                              ))
                        ])),
                    actions: <Widget>[
                      FlatButton(
                        child: Text('CANCEL'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      )
                    ],
                  );
              }
            });
          });
        });
  }

  Future<Widget> removeAgentConfirmation(
      BuildContext context, DataPointAgent agent) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text("Agent Removal Confirmation")),
            content: Container(
              child: Center(
                child: Text(
                    "Are you sure you want to remove Agent ${agent.agent_struct['name']['value']}"),
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text("YES"),
                onPressed: (() {
                  this.setState(() {
                    print(agent);
                    print(this.agents);
                    this.agents.remove(agent);
                    print(this.agents);
                  });
                  Navigator.of(context).pop();
                }),
              ),
              FlatButton(
                child: Text("NO"),
                onPressed: (() {
                  Navigator.of(context).pop();
                }),
              ),
            ],
          );
        });
  }

  Widget getList(BuildContext context, Agent agent) {
    agent.target_agents = [];
    MediaQueryData queryData;
    String cursor = "";
    ScrollController _scrollController = new ScrollController();
    queryData = MediaQuery.of(context);
    return ClientProvider(
      uri: Provider.of<AgentsManager>(context).loaded
          ? Provider.of<AgentsManager>(context).httpLink + "/graphql"
          : "None",
      child: Query(
          options: QueryOptions(
            documentNode: gql(AgentFetch().getDataPointAgents),
            variables: <String, String>{"id": agent.id, "cursor": cursor},
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
                      agent.translations[j["node"]["pair"]["value"]] == null
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
                              "value":
                                  agent.translations[j["node"]["pair"]["value"]]
                                      ["translation"],
                              "unit":
                                  agent.translations[j["node"]["pair"]["value"]]
                                      ["unit"]
                            });
                  }
                } else {
                  var state =
                      agent.translations[j["node"]["pair"]["key"]] == null
                          ? true
                          : false;
                  if (state) {
                    datapointagent.agent_struct.putIfAbsent(
                      j["node"]["pair"]["key"],
                      () => j["node"]["pair"]["value"],
                    );
                  } else {
                    datapointagent.agent_struct.putIfAbsent(
                      agent.translations[j["node"]["pair"]["key"]]
                          ["translation"],
                      () => j["node"]["pair"]["value"],
                    );
                  }
                }
                if (agent.target_agents.contains(datapointagent) == false) {
                  agent.addTarget(datapointagent);
                }
              }
            }
            final Map pageInfo = result.data['allDatapoints']['pageInfo'];
            final String fetchMoreCursor = pageInfo['endCursor'];

            FetchMoreOptions opts = FetchMoreOptions(
                variables: {'id': agent.id, 'cursor': fetchMoreCursor},
                updateQuery: (previousResultData, fetchMoreResultData) {
                  for (var i in fetchMoreResultData.data["allDatapoints"]
                      ["edges"]) {
                    DataPointAgent datapointagent = new DataPointAgent(
                        agent.id.toString(), i["node"]["idxDatapoint"]);
                    for (var j in i["node"]["glueDatapoint"]["edges"]) {
                      if (j["node"]["pair"]["value"] == "pattoo_key") {
                        var state =
                            agent.translations[j["node"]["pair"]["value"]] ==
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
                                    "value": agent.translations[j["node"]
                                        ["pair"]["value"]]["translation"],
                                    "unit": agent.translations[j["node"]["pair"]
                                        ["value"]]["unit"]
                                  });
                        }
                      } else {
                        var state =
                            agent.translations[j["node"]["pair"]["key"]] == null
                                ? true
                                : false;
                        if (state) {
                          datapointagent.agent_struct.putIfAbsent(
                            j["node"]["pair"]["key"],
                            () => j["node"]["pair"]["value"],
                          );
                        } else {
                          datapointagent.agent_struct.putIfAbsent(
                            agent.translations[j["node"]["pair"]["key"]]
                                ["translation"],
                            () => j["node"]["pair"]["value"],
                          );
                        }
                      }
                      if (agent.target_agents.contains(datapointagent) ==
                          false) {
                        agent.addTarget(datapointagent);
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

            return Column(
              children: [
                Expanded(
                  child: ListView(
                      controller: _scrollController,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      children: <Widget>[
                        for (var agent in agent.target_agents)
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
                                "Datapoint Agent ID: ${agent.datapoint_id}",
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
                                setState(() {
                                  if (!this.agents.contains(agent)) {
                                    this.agents.add(agent);
                                  }

                                  Navigator.pop(context);
                                });
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
              ],
            );
          }),
    );
  }

  Future addFavourite() async {
    String id = this.chart.idxChart;
    int order =
        Provider.of<UserState>(context, listen: false).favCharts.length + 1;
    String userId = Provider.of<UserState>(context, listen: false).idxUser;
    QueryOptions options = QueryOptions(
        documentNode: gql(AgentFetch().createFavouriteChart),
        variables: {
          "idxChart": id,
          "idxUser": userId,
          "order": order.toString()
        });
    GraphQLClient _client = GraphQLClient(
      cache: InMemoryCache(),
      link: new HttpLink(
          uri: Provider.of<AgentsManager>(context, listen: false).httpLink +
              "/graphql"),
    );
    QueryResult result = await _client.query(options);
    Provider.of<UserState>(context, listen: false).loadFavourites(context);
    Provider.of<UserState>(context, listen: false).favCharts.add(this.chart);
    setState(() {});
  }

  Future removeFavourite() async {
    List favCharts =
        Provider.of<UserState>(context, listen: false).charts.values.toList();
    String favId;
    for (var data in favCharts) {
      if (data["chart"] == this.chart) {
        favId = data["idFavorite"];
      }
    }
    QueryOptions options = QueryOptions(
        documentNode: gql(AgentFetch().removeFavouriteChart),
        variables: {"idxFavorite": favId});
    GraphQLClient _client = GraphQLClient(
      cache: InMemoryCache(),
      link: new HttpLink(
          uri: Provider.of<AgentsManager>(context, listen: false).httpLink +
              "/graphql"),
    );
    QueryResult result = await _client.query(options);
    Provider.of<UserState>(context, listen: false).loadFavourites(context);
    Provider.of<UserState>(context, listen: false).favCharts.remove(this.chart);
    setState(() {});
  }

  String information(DataPointAgent agent) {
    var information = "ID : ${agent.datapoint_id}";
    for (MapEntry e in agent.agent_struct.entries) {
      if (e.key != "name") {
        information += "\n${e.key} : ${e.value}";
      }
    }
    return information;
  }

  List<TimeSeriesSales> parseProducts(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

    List<TimeSeriesSales> data = [];
    for (var i in parsed) {
      if (i["value"] != null) {
        TimeStamp date = new TimeStamp(
            value: i["value"].round(), timestamp: (i["timestamp"]));
        data.add(TimeSeriesSales(date.Timestamp, date.value));
      }
    }
    return data;
  }

  fetchTimeSeries(List datapoints, int timeframe) async {
    var client = new http.Client();
    List data_ = new List();
    this.agents = datapoints;
    print(agents);
    this.vibrationData = List<Series<TimeSeriesSales, DateTime>>();
    for (var agent in datapoints) {
      try {
        var result = await client.get(Provider.of<AgentsManager>(context,
                    listen: false)
                .httpLink +
            '/rest/data/${agent.datapoint_id}?secondsago=${timeframe ?? this.timeframe["mm"]}');

        if (result.statusCode == 200) {
          data_.add(parseProducts(result.body));
        } else {
          throw Exception('Unable to fetch TimeSeries Data from the REST API');
        }
      } finally {}
    }
    client.close();
    print(data_.length.toString() + " Bout this big");
    return data_;
  }
}
