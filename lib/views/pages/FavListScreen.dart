import 'package:flutter/material.dart';
import 'package:pattoomobile/controllers/user_controller.dart';
import 'package:pattoomobile/models/view_models/user.dart';
import 'package:pattoomobile/widgets/AgentOptions.dart';
import 'package:pattoomobile/api/api.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'dart:convert';
import 'package:pattoomobile/models/agent.dart';
import 'package:pattoomobile/widgets/Display-Messages.dart';
import 'package:provider/provider.dart';
import 'package:pattoomobile/controllers/theme_manager.dart';
import 'package:pattoomobile/controllers/agent_controller.dart';
import 'package:pattoomobile/widgets/circleMenu.dart';
//import 'package:pattoomobile/models/view_models/user';


class FavAgentsList extends StatelessWidget {

  Widget getUserData(BuildContext context) {
    Map translationMap = new Map();
    ScrollController _scrollController = new ScrollController();
    return (Provider.of<UserDataManager>(context).loaded == false)
        ? DisplayMessage()
        : Query(
        options: QueryOptions(
          documentNode: gql(AgentFetch().getFavoriteData),
          variables: <String, String>{
            // set cursor to null so as to start at the beginning
            // 'cursor': 10
          },
        ),
        builder: (QueryResult result, {refetch, FetchMore fetchMore}) {
          if (result.loading && result.data == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (result.hasException) {
            return Text('\nErrors: \n  ' + result.exception.toString());
          }
          for (var i in result.data["getFavoriteData"]["edges"]) {
            translationMap.putIfAbsent(
                i["node"]["id"], () => i["node"]["username"]);
          }
          return Query(
              options: QueryOptions(
                documentNode: gql(AgentFetch().getFavoriteData),
                variables: <String, String>{
                  // set cursor to null so as to start at the beginning
                  // 'cursor': 10
                },
              ),
              builder: (QueryResult result,
                  {refetch, FetchMore fetchMore}) {
                if (result.loading && result.data == null) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (result.hasException) {
                  return Text(
                      '\nErrors: \n  ' + result.exception.toString());
                }

                if (result.data["favoriteUser"]["edges"].length == 0 &&
                    result.exception == null) {
                  return Column(
                    children: <Widget>[
                      SizedBox(
                        height: 250,
                      ),
                      Text('No Favourites available',
                          style: Theme.of(context).textTheme.headline6),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                          height: 200,
                          child: Image.asset(
                            'images/waiting.png',
                            fit: BoxFit.cover,
                          )),
                    ],
                  );
                }

                ;

                for (var i in result.data['allUser']['edges']) {
                  User user = new User(i["node"]["id"],
                      translationMap[i["node"]["order"]]);
                  Provider.of<UserDataManager>(context, listen: false)
                      .users;
                  var translations = i["node"]["pairXlateGroup"]
                  ["pairXlatePairXlateGroup"]["edges"];
                  for (var translation in translations) {
                   user.translations.putIfAbsent(
                        translation["node"]["key"],
                            () => {
                          "translation": translation["node"]
                          ["translation"],
                          "unit": translation["node"]["units"]
                        });
                  }
                }
                final Map pageInfo = result.data['allAgent']['pageInfo'];
                final String fetchMoreCursor = pageInfo['endCursor'];

                FetchMoreOptions opts = FetchMoreOptions(
                  variables: {'cursor': fetchMoreCursor},
                  updateQuery: (previousResultData, fetchMoreResultData) {
                    // this is where you combine your previous data and response
                    // in this case, we want to display previous repos plus next repos
                    // so, we combine data in both into a single list of repos
                    for (var i in fetchMoreResultData["allAgent"]
                    ["edges"]) {
                      Agent agent = new Agent(i["node"]["idxAgent"],
                          translationMap[i["node"]["agentProgram"]]);
                      Provider.of<UserDataManager>(context, listen: false)
                          .users;
                      var translations = i["node"]["pairXlateGroup"]
                      ["pairXlatePairXlateGroup"]["edges"];
                      for (var translation in translations) {
                        agent.translations.putIfAbsent(
                            translation["node"]["key"],
                                () => {
                              "translation": translation["node"]
                              ["translation"],
                              "unit": translation["node"]["units"]
                            });
                      }
                    }
                  },
                );

                _scrollController
                  ..addListener(() {
                    if (_scrollController.position.pixels ==
                        _scrollController.position.maxScrollExtent) {
                      if (!result.loading) {
                        fetchMore(opts);
                      }
                    }
                  });

                return Column(children: [
                  Expanded(
                      child: GridView(
                          controller: _scrollController,
                          scrollDirection: Axis.vertical,
                          gridDelegate:
                          SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2),
                          shrinkWrap: true,
                          children: <Widget>[
                            for (var agent
                            in Provider.of<UserDataManager>(context)
                                .userData)
                              agentButton(context, agent),
                            if (result.loading)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  CircularProgressIndicator(),
                                ],
                              )
                          ]))
                ]);
              });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favourite Charts', style: TextStyle(color: Colors.white)),
        backgroundColor:
        Provider.of<ThemeManager>(context).themeData.backgroundColor,
      ),
      body: Center(
        child: Stack(
          children: <Widget>[
            getUserData(context),
          ],
        ),
      ),
    );
  }

  String getPrettyJSONString(Object jsonObject) {
    return const JsonEncoder.withIndent('  ').convert(jsonObject);
  }
}
