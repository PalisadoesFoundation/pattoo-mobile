
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
        datapointAgent {
          edges {
            node {
              agent {
                idxAgent
                idxPairXlateGroup
                agentId
                agentPolledTarget
                agentProgram
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