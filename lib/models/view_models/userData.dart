import 'dart:core';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:pattoomobile/api/api.dart';
import 'package:pattoomobile/controllers/agent_controller.dart';
import 'package:pattoomobile/controllers/client_provider.dart';
import 'package:pattoomobile/controllers/theme_manager.dart';
import 'package:pattoomobile/controllers/userState.dart';
import 'package:pattoomobile/models/view_models/user.dart';
import 'package:provider/provider.dart';

void main() => runApp(DataDisplay());

class DataDisplay extends StatelessWidget {

  @override

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
        home: ListPage(),
    ),
    client: client,
    );
  }
}

class ListPage extends StatelessWidget {

  get cursor => null;

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
           "cursor": cursor,
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
          List favList = result.data['allUser']['edges']['node']['favoriteUser']['edges']['node'];

          return ListView.builder(
              itemCount: favList.length,
              itemBuilder: (context, index) {
                final data = favList[index];

                log(data['allUser']['edges']['node']['id']);
                return Text(data['name']);
              });
        })
    );
  }
}


