
import './datapoint.dart';
class DataPointAgent {
  String agent_id;
  String datapoint_id;
  Map<String,dynamic> agent_struct = new Map<String,dynamic>();
  DataPointAgent(
    this.agent_id,
    this.datapoint_id
  );
  DataPoint datapoints;


addDataPoint(DataPoint datapoint){
    this.datapoints = datapoint;
  }


  @override
  String toString() => 'DataPointAgent(Agent ID: $agent_id,  ID: $datapoint_id)';
}