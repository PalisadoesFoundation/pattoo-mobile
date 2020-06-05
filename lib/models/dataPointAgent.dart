import 'dart:convert';

import './datapoint.dart';
class DataPointAgent {
  String agent_id;
  String id;
  DataPointAgent(
    this.agent_id,
    this.id,
  );
  List datapoints = new List();


addDataPoint(DataPoint datapoint){
    this.datapoints.add(datapoint);
  }


  Map<String, dynamic> toMap() {
    return {
      'agent_id': agent_id,
      'id': id,
    };
  }



  String toJson() => json.encode(toMap());


  @override
  String toString() => 'DataPointAgent(agent_id: $agent_id, id: $id)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is DataPointAgent &&
      o.agent_id == agent_id &&
      o.id == id;
  }

  @override
  int get hashCode => agent_id.hashCode ^ id.hashCode;
}




