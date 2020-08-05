import 'package:flutter/cupertino.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:pattoomobile/models/view_models/user.dart';

class Services{
  static const String url = "http://calico.palisadoes.org/pattoo/api/v1/web/graphql";

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

  static Future<List<User>> getUsers() async{
    try{
      final response = await http.get(url);
      if(200 == response.statusCode)
      {
        //final List<User> users = userFromJson(response.body) as List<User>;
        //return users;
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

}

