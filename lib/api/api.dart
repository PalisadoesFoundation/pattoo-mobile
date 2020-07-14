
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
        id
        agentProgram
        idxPairXlateGroup
        pairXlateGroup {
          pairXlatePairXlateGroup {
            edges {
              node {
                idxPairXlate
                key
                translation
                units
              }
            }
          }
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
String getTimeData = """
query getTimeSeries(\$id: String){
  allDatapoints(idxDatapoint:\$id) {
    edges {
				node{
          dataChecksum(last:1000000){
            edges{
              node{
                value
                timestamp
                }
              }
            }
        }
    }
  }
}

""";

//Favourite

String getFavouriteData ="""
query{
  allFavorite {
    edges {
      node {
        id
        idxFavorite
        order
        user {
          id
          idxUser
          username
          firstName
          lastName
        }
        chart {
          name
          chartDatapointChart {
            edges {
              node {
                idxDatapoint
              }
            }
          }
        }
      }
    }
  }
}

""";
}
