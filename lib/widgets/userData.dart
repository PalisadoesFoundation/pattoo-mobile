import 'dart:core';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:pattoomobile/controllers/userState.dart';
import 'package:pattoomobile/models/view_models/user.dart';
import 'package:provider/provider.dart';
import 'package:flutter_test/flutter_test.dart';

//void main() => runApp(DataDisplay());

class DataDisplay extends StatefulWidget {
  DataDisplay(): super();
  @override
  _DataDisplayState createState() => _DataDisplayState();
}

class _DataDisplayState extends State<DataDisplay> {


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
              Map favdata = result.data.data;
              var edgeList = favdata["allUser"]["edges"];

              var data = new List<Chart>();//create new instance of list, passing chart object to create new list of charts
              for( var edge in  edgeList)
              {
                var favList = edge["node"]["favoriteUser"]["edges"];
                //print(favList);
                for(var fav in favList)
                {
                  Chart userFavChart = new Chart();
                  userFavChart.populateFromMap(fav);
                  data.add(userFavChart);
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
            })
    );
  }
}

void main()
{
  testWidgets('Display user favs', (WidgetTester tester) async{
    await tester.pumpWidget(ListScreen());
    var appBar = find.byType(Card);
    expect(appBar, findsOneWidget);
  });
}