import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' hide TextStyle, Axis;
import 'package:flutter/services.dart';
import 'package:pattoomobile/api/api.dart';
import 'package:pattoomobile/chartdir/chart_util.dart';
import 'package:pattoomobile/controllers/agent_controller.dart';
import 'package:pattoomobile/models/dataPointAgent.dart';
import 'package:pattoomobile/models/timestamp.dart';
import 'package:pattoomobile/views/pages/FullScreenChart.dart';
import 'package:pattoomobile/widgets/MetaDataTile.dart';
import 'package:pattoomobile/widgets/SampleChart.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class Chart extends StatelessWidget {
  final DataPointAgent agent;
  Chart(this.agent);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChartScreen(
        title: agent.agent_struct["name"]["value"], agent: this.agent);
  }
}

class ChartScreen extends StatefulWidget {
  ChartScreen({Key key, this.title, DataPointAgent this.agent})
      : super(key: key);
  final DataPointAgent agent;
  final String title;

  @override
  _ChartScreenState createState() => _ChartScreenState(agent);
}

class _ChartScreenState extends State<ChartScreen> {
  DataPointAgent agent;
  _ChartScreenState(this.agent);
  List<TimeSeriesSales> data_;
  List<TimeSeriesSales> cdata_;
  var fav_color = Colors.grey[100];
  bool favourite = false;
  Widget chart;
  final List<bool> isSelected = [false, false, true];
  List<Series<TimeSeriesSales, DateTime>> vibrationData;
  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData;

    queryData = MediaQuery.of(context);
    ChartUtil().getChartData().then((vibrationData) {
      setState(() {
        this.vibrationData = vibrationData;
      });
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(
          agent.agent_struct["name"]["value"],
        ),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        height: 1000.0,
        padding: EdgeInsets.all(8.0),
        color: Colors.grey[100],
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                  color: Colors.white,
                  width: queryData.size.width * 0.9,
                  height: queryData.size.width * 0.8,
                  child: Column(
                    children: <Widget>[
                      FutureBuilder(
                          future: this.fetchTimeSeries(agent.datapoint_id),
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
                              vibrationData = [
                                Series<TimeSeriesSales, DateTime>(
                                  id: 'Sales',
                                  colorFn: (_, __) =>
                                      MaterialPalette.blue.shadeDefault,
                                  domainFn: (TimeSeriesSales sales, _) =>
                                      sales.time,
                                  measureFn: (TimeSeriesSales sales, _) =>
                                      sales.sales,
                                  data: snapshot.data,
                                )
                              ];
                              this.chart = Hero(
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
                                      defaultRenderer: LineRendererConfig(
                                          includeArea: true, stacked: true),
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
                                  height: queryData.size.height * 0.35,
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
                          Wrap(direction: Axis.horizontal, children: <Widget>[
                            IconButton(
                                icon: Icon(Icons.favorite, color: fav_color),
                                onPressed: () {
                                  setState(() {
                                    favourite = !favourite;
                                    fav_color = favourite
                                        ? Colors.red
                                        : Colors.grey[100];
                                  });
                                }),
                            IconButton(
                              icon: Icon(
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
                      Container(
                        child: LayoutBuilder(builder: (context, constraints) {
                          return ToggleButtons(
                            renderBorder: false,
                            constraints: BoxConstraints.expand(
                                height: constraints.maxHeight * 0.5,
                                width: constraints.maxWidth * 0.325),
                            borderRadius: BorderRadius.circular(5),
                            children: <Widget>[
                              Text("1D",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                              Text("1M",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                              Text("1Y",
                                  style: TextStyle(
                                      fontSize: 18,
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
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  color: Colors.white,
                  width: queryData.size.width * 0.9,
                  child: Column(
                    children: ListTile.divideTiles(
                      context: context,
                      tiles: [
                        ListTile(title: Text("MetaData")),
                        for (MapEntry e in agent.agent_struct.entries)
                          if (e.key != "name")
                            MetaDataTile(
                              title: e.key,
                              value: e.value,
                            )
                      ],
                    ).toList(),
                  ),
                )
              ],
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0, // this will be set when a new tab is tapped
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.home),
            title: new Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.favorite),
            title: new Text('Favorites'),
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), title: Text('Settings'))
        ],
      ),
    );
  }

  List<TimeSeriesSales> parseProducts(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    List<TimeSeriesSales> data = [];
    for (var i in parsed) {
      TimeStamp date =
          new TimeStamp(value: i["value"].round(), timestamp: (i["timestamp"]));
      data.add(TimeSeriesSales(date.Timestamp, date.value));
    }
    this.data_ = data;
    return data;
  }

  fetchTimeSeries(String datapoint_id) async {
    var client = new http.Client();
    try {
      var result = await client.get(
          'http://calico.palisadoes.org/pattoo/api/v1/web/rest/data/$datapoint_id');
      if (result.statusCode == 200) {
        return parseProducts(result.body);
      } else {
        throw Exception('Unable to fetch TimeSeries Data from the REST API');
      }
    } finally {
      client.close();
    }

/*     if (result.data["allDatapoints"]["edges"].length == 0 &&
        result.exception == null) {
      print("Empty Data");
    } else {
      List<TimeSeriesSales> data = List();
      var times = result.data["allDatapoints"]["edges"][0]["node"]
          ["dataChecksum"]["edges"];
      for (var time in times) {
        if (time["node"]["value"] == "0E-10") {
          TimeStamp date = new TimeStamp(
              value: 0, timestamp: int.parse(time["node"]["timestamp"]));
          data.add(TimeSeriesSales(date.Timestamp, date.value));
        } else {
          TimeStamp date = new TimeStamp(
              value: double.parse(time["node"]["value"]).round(),
              timestamp: int.parse(time["node"]["timestamp"]));
          data.add(TimeSeriesSales(date.Timestamp, date.value));
        }
      }
      this.data_ = data;
      return data.where((x) => this.data_.indexOf(x) % 12 == 0).toList();
    } */
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
        this.chart = TimeSeriesChart(vibrationData,
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
