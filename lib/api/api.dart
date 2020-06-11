
class AgentFetch{
String getAllAgents="""
query getAllAgents(\$cursor:String){
  allAgentXlate(first: 12, after:\$cursor) {
    edges {
      node {
        id
        idxAgentXlate
        idxLanguage
        agentProgram
        translation
        enabled
        tsCreated
        tsModified
        language {
          id
          name
          code
          idxLanguage
        }
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
