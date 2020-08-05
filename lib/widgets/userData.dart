import 'dart:core';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:pattoomobile/controllers/userState.dart';
import 'package:pattoomobile/models/view_models/user.dart';
import 'package:pattoomobile/widgets/userDataService.dart';
import 'package:provider/provider.dart';
import 'dart:collection';

void main() => runApp(DataDisplay());

class DataDisplay extends StatefulWidget {
  DataDisplay(): super();
  @override
  _DataDisplayState createState() => _DataDisplayState();
}

class _DataDisplayState extends State<DataDisplay> {
  List<User> _users;
  bool _loading;


  Future<List<User>> fetchData() async {
    try{
      final response = await http.get("http://calico.palisadoes.org/pattoo/api/v1/web/graphql");
      if(200 == response.statusCode)
      {
//        final List<User> users = userFromJson(response.body) as List<User>;
//        return users;
      }
      else
      {
        return List<User>();
      }
    }
    catch(e)
    {
      return List<User>();
    }
  }

  @override
  void initState()
  {
    super.initState();
    _loading = true;
    Services.getUsers().then((users)
    {
      setState(() {
        _users =users;
        _loading = false;
      });
    });
  }


  Widget build(BuildContext context) {

    final HttpLink httpLink =
    HttpLink(uri: "http://calico.palisadoes.org/pattoo/api/v1/web/graphql");
    final ValueNotifier<GraphQLClient> client = ValueNotifier<GraphQLClient>(
      GraphQLClient(
        link: httpLink,
        cache: OptimisticCache(
          dataIdFromObject: typenameDataIdFromObject,
        ),
      ),
    );
    return GraphQLProvider(
      child: MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: ListScreen(),
      ),
      client: client,
    );
  }
}

class ListPage extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    final userState = Provider.of<UserState>(context);

    final String getFavoriteData = """
        query getFavoriteData(\$username: String)
        {
          allUser(username: \$username) {
            edges {
              node {
                id
                username
                favoriteUser {
                  edges {
                    node {
                      order 
                      chart {
                        id
                        idxChart
                        name
                      }
                    }
                  }
                }
              }
            }
          }
        }
        """;

    return Scaffold(
        appBar: AppBar(
          title: Text("My Favourites"),
        ),
        body: Query(
            options: QueryOptions(
                documentNode: gql(getFavoriteData),
                variables: {
                  "username": userState.getUserName,
                }
            ),
            // ignore: missing_return
            builder: (QueryResult result, {VoidCallback refetch, FetchMore fetchMore}) {
              if (result.hasException) {
                return Text(result.exception.toString());
              }

              if (result.loading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              //print(result.data.data);
              //print(result.data.data);
              Map favdata = result.data.data;
              var edgeList = favdata["allUser"]["edges"];

              var data = new List<Chart>();//create new instance of list, passing chart object to create new list of charts
              for( var edge in  edgeList)
              {
                var favList = edge["node"]["favoriteUser"]["edges"];
                //print(favList);
                for(var fav in favList)
                {
//                      var chart = fav["node"]["chart"];
//                      print(chart);

                  Chart a = new Chart();
                  a.populateFromMap(fav);
                  data.add(a);


                }
              }



              print(data.length);




//              print (favdata);
//
//              print (favdata["allUser"]["edges"]);
//              var edges = favdata["allUser"]["edges"];
//              print (edges[0]);
//              // create a new user object andfill it wiht the map data
//              User user = new User();
//              user.populateFromMap(edges[0]);
//              print(user.favoriteCharts[0].id);
              return Text('Hi');
//              return Text(user.favoriteCharts[0].id);

//             return Card(
//              child: Column(
//                mainAxisSize: MainAxisSize.min,
//                children: <Widget>[
//                  ListTile(
//                    title: Text(user.favoriteCharts[0].id),
//                    subtitle: Text(user.favoriteCharts[0].idxChart),
//                  )
//                ],
//              ),
//             );
            })
    );
  }
}


class ListScreen extends StatefulWidget {
  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {

  @override
  Widget build(BuildContext context) {
    final userState = Provider.of<UserState>(context);

    final String getFavoriteData = """
        query getFavoriteData(\$username: String)
        {
          allUser(username: \$username) {
            edges {
              node {
                id
                username
                favoriteUser {
                  edges {
                    node {
                      order 
                      chart {
                        id
                        idxChart
                        name
                      }
                    }
                  }
                }
              }
            }
          }
        }
        """;

    return Scaffold(
        appBar: AppBar(
          title: Text("My Favourites"),
        ),
        body: Query(
            options: QueryOptions(
                documentNode: gql(getFavoriteData),
                variables: {
                  "username": userState.getUserName,
                }
            ),
            // ignore: missing_return
            builder: (QueryResult result, {VoidCallback refetch, FetchMore fetchMore}) {
              if (result.hasException) {
                return Text(result.exception.toString());
              }

              if (result.loading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              //print(result.data.data);
              //print(result.data.data);
              Map favdata = result.data.data;
              var edgeList = favdata["allUser"]["edges"];

              var data = new List<Chart>();//create new instance of list, passing chart object to create new list of charts
              for( var edge in  edgeList)
              {
                var favList = edge["node"]["favoriteUser"]["edges"];
                //print(favList);
                for(var fav in favList)
                {
//                      var chart = fav["node"]["chart"];
//                      print(chart);

                  Chart a = new Chart();
                  a.populateFromMap(fav);
                  data.add(a);


                }
              }



              print(data.length);


              return Center(
                  child: ReorderableListView(
                    children: List.generate(data.length, (index)
                    {
                      return Card(
                        margin: EdgeInsets.only(left: 5, top: 10, right: 5, bottom: 10),
                        elevation: 10,
                        key: UniqueKey(),
                        child: ListTile(
                          title: Text(data[index].id),
                          subtitle: Text(data[index].idxChart),
                        ),
                      );
                    }),

                    onReorder: (int oldIndex, int newIndex)
                    {
                      setState(()
                      {
                        if (newIndex > oldIndex) {
                          newIndex -= 1;
                        }
                        final Chart newString = data.removeAt(oldIndex);
                        data.insert(newIndex, newString);
                      });
                    },
                  )
              );

//              print (favdata);
//
//              print (favdata["allUser"]["edges"]);
//              var edges = favdata["allUser"]["edges"];
//              print (edges[0]);
//              // create a new user object andfill it wiht the map data
//              User user = new User();
//              user.populateFromMap(edges[0]);
//              print(user.favoriteCharts[0].id);
              //return Text('Hi');
//              return Text(user.favoriteCharts[0].id);

//             return Card(
//              child: Column(
//                mainAxisSize: MainAxisSize.min,
//                children: <Widget>[
//                  ListTile(
//                    title: Text(user.favoriteCharts[0].id),
//                    subtitle: Text(user.favoriteCharts[0].idxChart),
//                  )
//                ],
//              ),
//             );
            })
    );
  }
}
