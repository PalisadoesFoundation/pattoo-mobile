//Variables for charts

import 'dart:convert';

import 'package:pattoomobile/models/dataPointAgent.dart';

class Chart {
  String idxChart;
  String name;
  Chart({this.idxChart, this.name, this.datapoints});
  Map<String, DataPointAgent> datapoints;

  Chart copyWith({
    String idxChart,
    String name,
  }) {
    return Chart(
      idxChart: idxChart ?? this.idxChart,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'idxChart': idxChart,
      'name': name,
    };
  }

  static Chart fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Chart(
      idxChart: map['idxChart'],
      name: map['name'],
    );
  }

  String toJson() => json.encode(toMap());

  static Chart fromJson(Map<String, dynamic> json) {
    Map<String, DataPointAgent> datapoints = new Map<String, DataPointAgent>();
    var id = json['node']['idxChart'];
    var name = json['node']['name'];
    for (var node in json['node']['chartDatapointChart']['edges']) {
      var idxChartDatapoint = node['node']['idxChartDatapoint'];
      var idxDatapoint = node['node']['datapoint']['idxDatapoint'];
      var idxAgent = node['node']['datapoint']['idxAgent'];
      DataPointAgent dpagent = new DataPointAgent(idxAgent, idxDatapoint);
      for (var data in node['node']['datapoint']['glueDatapoint']['edges']) {
        dpagent.agent_struct.addAll(
            {data["node"]["pair"]["key"]: data["node"]["pair"]["value"]});
      }
      datapoints.addAll({idxChartDatapoint: dpagent});
    }
    return Chart(idxChart: id, name: name, datapoints: datapoints);
  }

  @override
  String toString() => 'Chart(idxChart: $idxChart, name: $name)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Chart && o.idxChart == idxChart && o.name == name;
  }

  @override
  int get hashCode => idxChart.hashCode ^ name.hashCode;
}
