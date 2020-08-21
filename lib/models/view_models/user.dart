class User {
  String id = "";
  static int idxUser = 0;
  String username = "";
//  String chart_id;
//  String chartname;
//  List fav_agents = new List();
//  Map translations = new Map();
//  Map<String,dynamic> agent_struct = new Map<String,dynamic>();
//

  User();

  void populateFromMap(Map userMapData) {
    id = userMapData["node"]["id"];
    idxUser = userMapData["node"]["idxUser"];
    username = userMapData["node"]["username"];
  }

  @override
  String toString() => 'Agent(id: $id)';
}
