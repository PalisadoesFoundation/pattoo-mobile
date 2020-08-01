import 'dart:core';

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
    {
      allUser(username: "${userState.getUserName}") {
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
          variables: <String, String>{
           "name": userState.getUserName,
           "cursor": cursor,
          }
        ),
        // ignore: missing_return
        builder: (QueryResult result, {refetch, FetchMore fetchMore}) {
          if (result.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (result.data == null) {
            return Text("User has no favourites!");
          }

          if (result.data != null) {
            return Text("User has favourites!");
          }

        })


    );


  }
}


