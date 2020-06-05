import 'package:flutter/material.dart';
import 'package:pattoomobile/models/datapoint.dart';
import 'package:pattoomobile/models/dataPointAgent.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:pattoomobile/api/api.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:pattoomobile/models/agent.dart';
class AgentsManager with ChangeNotifier {
List agents = new List();
HttpLink _httpLink = new HttpLink(uri:"http://calico.palisadoes.org/pattoo/api/v1/web/graphql");
QueryResult result;
 /// Use this method on UI to get selected theme.
 updateAgents() async{
   QueryOptions options = QueryOptions(
    documentNode: gql(AgentFetch.getAgents),
    );
    GraphQLClient _client = GraphQLClient(
        cache: InMemoryCache(),
        link: _httpLink,
    );
    QueryResult result = await _client.query(options);  
    for(var i in result.data["allAgent"]["edges"]){
     Agent agent = new Agent(i["node"]["idxAgent"],i["node"]["agentProgram"]);  
     this.agents.add(agent);
    } }

  updateDatapoints(int id) async{
    QueryOptions options = QueryOptions(
    documentNode: gql(AgentFetch.getDataPointAgents), variables: {"id": id.toString()},    );
    GraphQLClient _client = GraphQLClient(
        cache: InMemoryCache(),
        link: _httpLink,
    );
    QueryResult result = await _client.query(options);  
    for(var i in result.data["allAgent"]["edges"][0]["node"]["datapointAgent"]["Edges"]){
     DataPointAgent datapointagent = new DataPointAgent(id.toString(),i["node"]["id"]);  
     this.agents[id-1].addTarget(datapointagent);
    }    
  }
  List get agentsList{
    return this.agents;
  }
}