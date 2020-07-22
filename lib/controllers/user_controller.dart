
import 'package:flutter/material.dart';
import 'package:pattoomobile/api/api.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class UserDataManager with ChangeNotifier {
  List users = new List();
  String httpLink;
  QueryResult result;
  bool loaded = false;
  QueryOptions current_options;
  /// Use this method on UI to get selected theme.
  String get link {
    return this.httpLink;
  }
  setLink(String link){
    this.httpLink = link;
  }

  Future<String> getFavoriteData(Map user) async {
    var name = "";
    String id_pair = user["id"];
    QueryOptions options_ = QueryOptions(
        documentNode: gql(AgentFetch().getFavoriteData),
        variables: <String, dynamic>{"id": id_pair});
    GraphQLClient _client = GraphQLClient(
      cache: InMemoryCache(),
      link: new HttpLink(uri: httpLink),
    );
    QueryResult result2 = await _client.query(options_);
    if (result2.data["favoriteUser"]["edges"].length == 0){
      return user["id"];
    }
    else{
      name = result2.data["favoriteUser"]["edges"][0]["node"]["name"];

      return name;
    }
  }

  List get userData {
    return this.users;
  }


}
