import 'dart:convert';
import './datapoint.dart';
class DataPointAgent {
  String agent_id;
  DataPointAgent({
    this.agent_id,
  });
  List datapoints = new List();

  DataPointAgent copyWith({
    String agent_id,
  }) {
    return DataPointAgent(
      agent_id: agent_id ?? this.agent_id,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'agent_id': agent_id,
    };
  }

  static DataPointAgent fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return DataPointAgent(
      agent_id: map['agent_id'],
    );
  }

  String toJson() => json.encode(toMap());

  static DataPointAgent fromJson(String source) => fromMap(json.decode(source));

  @override
  String toString() => 'DataPointAgent(agent_id: $agent_id)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is DataPointAgent &&
      o.agent_id == agent_id;
  }

  @override
  int get hashCode => agent_id.hashCode;

  addDataPoint(DataPoint datapoint){
    this.datapoints.add(datapoint);
  }
}
