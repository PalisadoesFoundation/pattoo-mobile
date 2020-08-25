import 'package:flutter/material.dart';
import 'package:pattoomobile/api/api.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:pattoomobile/models/agent.dart';

class AgentsManager with ChangeNotifier {
  List<Agent> agents = new List();
  String httpLink;
  QueryResult result;
  bool loaded = false;
  QueryOptions current_options;

  /// Use this method on UI to get selected theme.
  String get link {
    return this.httpLink;
  }

  setLink(String link) {
    this.httpLink = link;
  }

  Map<String, Agent> get agentsMap {
    Map<String, Agent> map = new Map<String, Agent>();
    for (Agent agent in agents) {
      map.addAll({agent.id: agent});
    }
    return map;
  }

/*   updateAgents() async {
    QueryOptions options = QueryOptions(
      documentNode: gql(AgentFetch().getAllAgents),
      variables: <String, String>{
        // set cursor to null so as to start at the beginning
        // 'cursor': 10
      },
    );
    GraphQLClient _client = GraphQLClient(
      cache: InMemoryCache(),
      link: new HttpLink(uri: this._httpLink),
    );
    QueryResult result = await _client.query(options);
    if (result.loading && result.data == null) {
      this.loading = true;
    }

    if (result.hasException) {
      print(result.exception.toString());
    }

    if (result.data["allAgentXlate"]["edges"].length == 0 &&
        result.exception == null) {
      print("Empty Data");
    } else {
      for (var i in result.data["allAgent"]["edges"]) {
        Agent agent;
        QueryOptions options2 = QueryOptions(
          documentNode: gql(AgentFetch().translateAgent),
          variables: <String, String>{"program": i["node"]["agentProgram"]},
        );
        GraphQLClient _client2 = GraphQLClient(
          cache: InMemoryCache(),
          link: new HttpLink(uri: this._httpLink),
        );
        QueryResult result2 = await _client2.query(options2);
        agent = new Agent(i["node"]["idxAgent"],
            result2.data["allAgentXlate"]["edges"][0]["node"]["translation"]);
        this.agents.add(agent);
      }
      this.loading = false;
    }
  } */

/*   updateDatapoints(int id) async{
    QueryOptions options = QueryOptions(
    documentNode: gql(AgentFetch().getDataPointAgents(id)));
    GraphQLClient _client = GraphQLClient(
        cache: InMemoryCache(),
        link: _httpLink,
    );
    QueryResult result = await _client.query(options);  
    for(var i in result.data["allDatapoints"]["edges"]){
        DataPointAgent datapointagent = new DataPointAgent(id.toString(),i["node"]["idxDatapoint"]); 
        for(var j in i["node"]["glueDatapoint"]["edges"]){
          String id_Pair = j["node"]["idxPair"];
          QueryOptions options = QueryOptions(
          documentNode: gql(AgentFetch().getTranslatedDataPointAgentName(int.parse(id_Pair))));
          GraphQLClient _client = GraphQLClient(
            cache: InMemoryCache(),
            link: _httpLink,
          );
          QueryResult result2 = await _client.query(options); 
          var name = result2.data["allPairXlate"]["edges"][0]["node"]["translation"];
          datapointagent.agent_struct.putIfAbsent(name, () => j["node"]["pair"]["value"]);
      }   
    print(datapointagent.agent_struct.toString());
    this.agents[id-1].addTarget(datapointagent);
    } 
  } */

  Future<String> getTranslatedName(Map agent) async {
    var name = "";
    String id_pair = agent["idxPair"];
    QueryOptions options_ = QueryOptions(
        documentNode: gql(AgentFetch().getTranslatedDataPointAgentName),
        variables: <String, dynamic>{"id": id_pair});
    GraphQLClient _client = GraphQLClient(
      cache: InMemoryCache(),
      link: new HttpLink(uri: httpLink + "/graphql"),
    );
    QueryResult result2 = await _client.query(options_);
    if (result2.data["allPairXlate"]["edges"].length == 0) {
      return agent["value"];
    } else {
      name = result2.data["allPairXlate"]["edges"][0]["node"]["translation"];

      return name;
    }
  }

  Future loadAgents(BuildContext context) async {
    QueryOptions options = QueryOptions(
      documentNode: gql(AgentFetch().translateAgent),
      variables: <String, String>{
        // set cursor to null so as to start at the beginning
        // 'cursor': 10
      },
    );
    GraphQLClient _client = GraphQLClient(
      cache: InMemoryCache(),
      link: new HttpLink(uri: this.httpLink + "/graphql"),
    );
    Map translationMap = Map();
    QueryResult result = await _client.query(options);
    for (var i in result.data["allAgentXlate"]["edges"]) {
      translationMap.putIfAbsent(
          i["node"]["agentProgram"], () => i["node"]["translation"]);
    }
    QueryOptions options2 = QueryOptions(
      documentNode: gql(AgentFetch().getAllAgents),
      variables: <String, String>{
        // set cursor to null so as to start at the beginning
        // 'cursor': 10
      },
    );
    GraphQLClient _client2 = GraphQLClient(
      cache: InMemoryCache(),
      link: new HttpLink(uri: this.httpLink + "/graphql"),
    );
    QueryResult result2 = await _client2.query(options2);
    for (var i in result2.data['allAgent']['edges']) {
      Agent agent = new Agent(
          i["node"]["idxAgent"], translationMap[i["node"]["agentProgram"]]);
      this.agents.add(agent);
      var translations =
          i["node"]["pairXlateGroup"]["pairXlatePairXlateGroup"]["edges"];
      for (var translation in translations) {
        agent.translations.putIfAbsent(
            translation["node"]["key"],
            () => {
                  "translation": translation["node"]["translation"],
                  "unit": translation["node"]["units"]
                });
      }
    }
  }

  List get agentsList {
    return this.agents;
  }
}
