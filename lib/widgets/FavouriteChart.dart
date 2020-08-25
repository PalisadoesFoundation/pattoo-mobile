import 'package:flutter/material.dart';
import 'package:pattoomobile/models/chart.dart';

class FavouriteChart extends StatefulWidget {
  final Chart chart;
  FavouriteChart({
    Key key,
    this.chart,
  });

  @override
  _FavouriteChartState createState() =>
      _FavouriteChartState(chart: this.chart, key: UniqueKey());
}

class _FavouriteChartState extends State<FavouriteChart> {
  final Chart chart;
  _FavouriteChartState({this.chart, Key key});
  @override
  Widget build(BuildContext context) {
    return ListTile(
      key: UniqueKey(),
      leading: Text(
        chart.name,
        key: UniqueKey(),
      ),
    );
  }
}
