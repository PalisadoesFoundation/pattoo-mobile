import 'dart:convert';

import './dataPointAgent.dart';

class Agent {
  String id;
  String program;
  List target_agents = new List();
  Map translations = new Map();
  Agent(
    this.id,
    this.program,
  );

  @override
  int get hashCode => id.hashCode ^ program.hashCode;

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Agent && o.id == id && o.program == program;
  }

  addTarget(DataPointAgent target) {
    this.target_agents.add(target);
  }

  String toJson() => json.encode(toMap());

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'program': program,
    };
  }

  @override
  String toString() => 'Agent(id: $id, program: $program)';
}
