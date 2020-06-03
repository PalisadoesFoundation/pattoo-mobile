import 'dart:convert';
import './dataPointAgent.dart';
class Agent {
  String id;
  String program;
  Agent(
    this.id,
    this.program,
  );
  List target_agents = new List();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'program': program,
    };
  }



  String toJson() => json.encode(toMap());


  @override
  String toString() => 'Agent(id: $id, program: $program)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is Agent &&
      o.id == id &&
      o.program == program;
  }

  @override
  int get hashCode => id.hashCode ^ program.hashCode;


  addTarget(DataPointAgent target){

  }
}
