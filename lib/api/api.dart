
class AgentFetch{
String translateAgent="""
query{
  allAgentXlate {
    edges {
      node {
        agentProgram
        translation
      }
    }
    pageInfo {
      startCursor
      endCursor
      hasNextPage
      hasPreviousPage
    }
  }
}

""";

String getAllAgents="""
query getAllAgents(\$cursor: String) {
  allAgent(first: 12, after: \$cursor) {
    edges {
      node {
        idxAgent
        agentId
        agentProgram
      }
    }
    pageInfo {
      startCursor
      endCursor
      hasNextPage
      hasPreviousPage
    }
  }
}


""";


String getTranslatedDataPointAgentName = """
query getTranslatedDataPoints(\$id: String){
  allPairXlate(idxPairXlate:\$id) {
    edges {
      node {
        id
        translation
      }
    }
  }
}



""";


String getDataPointAgents = """
query getDataPoints(\$id: String, \$cursor: String){
  allDatapoints(idxAgent:\$id, first:12, after:\$cursor) {
    edges {
      node {
        idxAgent
        idxDatapoint
				glueDatapoint{
          edges{
            node{
      				idxPair
              idxDatapoint
              pair{
                key
                value
              }
            }
          }
        }
      }
    }
    pageInfo{
      startCursor
      endCursor
      hasNextPage
      hasPreviousPage
    }
  }
}

""";
}
