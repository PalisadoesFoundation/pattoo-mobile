import 'dart:convert';

import '../dataPointAgent.dart';

class User{
  String id;
  String username;
  List fav_agents = new List();
  Map translations = new Map();

  User(
      this.id,
      this.username,
      );

//Not sure if this makes sense right here
  @override
  int get hashCode => id.hashCode ^ username.hashCode;

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is User && o.id == id && o.username == username;
  }

  addTarget(DataPointAgent target) {
    this.fav_agents.add(target);
  }

  String toJson() => json.encode(toMap());

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
    };
  }

  @override
  String toString() => 'Agent(id: $id, program: $username)';
}