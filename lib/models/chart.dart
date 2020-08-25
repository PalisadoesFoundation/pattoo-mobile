//Variables for charts

import 'dart:convert';

import 'package:pattoomobile/controllers/agent_controller.dart';
import 'package:pattoomobile/models/agent.dart';
import 'package:pattoomobile/models/dataPointAgent.dart';
import 'package:provider/provider.dart';

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
/*     for (MapEntry e in chart.datapoints.entries) {
      Agent agent = Provider.of<AgentsManager>(context, listen: false)
          .agentsMap[e.value.agent_id];
      print(agent);
    } */
  static Chart fromJson(Map<String, dynamic> json, context) {
    Map<String, DataPointAgent> datapoints = new Map<String, DataPointAgent>();
    var id = json['idxChart'];
    var name = json['name'];
    for (var node in json['chartDatapointChart']['edges']) {
      var idxChartDatapoint = node['node']['idxChartDatapoint'];
      var idxDatapoint = node['node']['datapoint']['idxDatapoint'];
      var idxAgent = node['node']['datapoint']['idxAgent'];
      DataPointAgent datapointagent =
          new DataPointAgent(idxAgent, idxDatapoint);
      Agent agent = Provider.of<AgentsManager>(context, listen: false)
          .agentsMap[idxAgent];
      for (var j in node['node']['datapoint']['glueDatapoint']['edges']) {
        if (j["node"]["pair"]["key"] == "pattoo_key") {
          var state = agent.translations[j["node"]["pair"]["value"]] == null
              ? true
              : false;
          if (state) {
            datapointagent.agent_struct.putIfAbsent("name",
                () => {"value": j["node"]["pair"]["value"], "unit": "None"});
          } else {
            datapointagent.agent_struct.putIfAbsent(
                "name",
                () => {
                      "value": agent.translations[j["node"]["pair"]["value"]]
                          ["translation"],
                      "unit": agent.translations[j["node"]["pair"]["value"]]
                          ["unit"]
                    });
          }
        } else {
          var state = agent.translations[j["node"]["pair"]["key"]] == null
              ? true
              : false;
          if (state) {
            datapointagent.agent_struct.putIfAbsent(
              j["node"]["pair"]["key"],
              () => j["node"]["pair"]["value"],
            );
          } else {
            datapointagent.agent_struct.putIfAbsent(
              agent.translations[j["node"]["pair"]["key"]]["translation"],
              () => j["node"]["pair"]["value"],
            );
          }
        }
        if (agent.target_agents.contains(datapointagent) == false) {
          agent.addTarget(datapointagent);
        }
      }
      datapoints.addAll({idxChartDatapoint: datapointagent});
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
