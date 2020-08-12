
class User{
   String id =  "";
   static int idxUser = 0;
   String username = "";
   List<Chart> favoriteCharts = [];
//  String chart_id;
//  String chartname;
//  List fav_agents = new List();
//  Map translations = new Map();
//  Map<String,dynamic> agent_struct = new Map<String,dynamic>();
//

  User();

  void populateFromMap(Map userMapData){
    id = userMapData["node"]["id"];
    idxUser = userMapData["node"]["idxUser"];
    username = userMapData["node"]["username"];
    List charts = userMapData["node"]["favoriteUser"]["edges"];

    for(var chart in charts){
      Chart tempChart = new Chart();
      tempChart.populateFromMap(chart);
      favoriteCharts.add(tempChart);
    }
  }

@override
String toString() => 'Agent(id: $id)';

}

class Chart{
  String order = "";
  String id = "";
  String name = "";
  String idxChart = "";

  Chart();

  void  populateFromMap(Map map){
    order = map["node"]["order"];
    id  = map["node"]["chart"]["id"];
    name =  map["node"]["chart"]["name"];
    idxChart =  map["node"]["chart"]["idxChart"];
  }
}