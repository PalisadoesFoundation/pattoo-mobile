import 'dart:convert';

import '../dataPointAgent.dart';

class User{
  String id;
  String username;
  String chart_id;
  String chartname;
  List fav_agents = new List();
  Map translations = new Map();
  Map<String,dynamic> agent_struct = new Map<String,dynamic>();
  User(
      this.id,
      this.username,
      );

  @override
  String toString() => 'Agent(id: $id, chartname: $chartname, ID: $chart_id)';

  //Retrieve user data
}