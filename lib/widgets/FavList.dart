import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:pattoomobile/api/api.dart';

class FavList extends StatefulWidget {
  @override
  _FavListState createState() => _FavListState();
}

class _FavListState extends State<FavList> {
  @override
  Widget build(BuildContext context) {

    Map translationMap = new Map();
    ScrollController _scrollController = new ScrollController();
    return Container(
      child: getFavQuery(),
    );
  }
}


Widget getFavQuery() {
  Future<String> getFavoriteData(Map user) async {
    var name = "";
    String id_pair = user["id"];
    QueryOptions options_ = QueryOptions(
        documentNode: gql(AgentFetch().getFavoriteData),
        variables: <String, dynamic>{"id": id_pair});
    GraphQLClient _client = GraphQLClient(
      cache: InMemoryCache(),
      //link: new HttpLink(uri: httpLink),
    );
    QueryResult result2 = await _client.query(options_);
    if (result2.data["favoriteUser"]["edges"].length == 0) {
      //return user["value"]; user has no favs
    }
    else {
//
    }
  }
}
