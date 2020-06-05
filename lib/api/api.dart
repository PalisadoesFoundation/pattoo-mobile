
class AgentFetch{
static String getAgents = """
query{
  allAgent {
    edges {
      node {
        idxAgent
        idxPairXlateGroup
        agentId
        agentPolledTarget
        agentProgram
      }
    }
  }
}
""";




static String getDataPointAgents = """
 query{ 
  allAgent(idxAgent:\$id) {
    edges {
      node {
        idxAgent
        idxPairXlateGroup
        agentId
        agentPolledTarget
        agentProgram
        datapointAgent {
          edges {
            node {
              idxAgent
              glueDatapoint {
                edges {
                  node {
                    pair {
                      key
                      value
                    }
                  }
                }
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