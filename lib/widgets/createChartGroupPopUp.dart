import 'dart:wasm';

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:pattoomobile/api/api.dart';
import 'package:pattoomobile/controllers/agent_controller.dart';
import 'package:pattoomobile/models/agent.dart';
import 'package:pattoomobile/models/dataPointAgent.dart';
import 'package:provider/provider.dart';

class ChartGroupPopUp extends StatefulWidget {
  final BuildContext context;
  final List<DataPointAgent> agents;
  ChartGroupPopUp({Key key, @required this.context, this.agents})
      : super(key: key);

  @override
  _chartGroupPopUpState createState() =>
      _chartGroupPopUpState(this.context, this.agents);
}

class _chartGroupPopUpState extends State<ChartGroupPopUp> {
  BuildContext context;
  List<DataPointAgent> agents;
  bool inAsync = false;
  _chartGroupPopUpState(this.context, this.agents);
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    List<Color> colors = [Colors.white, Colors.grey[100]];
    var _nameController = TextEditingController();
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: inAsync,
        progressIndicator: CircularProgressIndicator(),
        child: Builder(builder: (context) {
          return AlertDialog(
            title: Row(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.blue[900]),
                  child: Center(
                    child: Icon(
                      Icons.multiline_chart,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Text("Create Chart Group")
              ],
            ),
            content: Container(
                width: queryData.size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 20),
                    Form(
                      key: _formKey,
                      child: TextFormField(
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Chart name can not be blank';
                            }
                            return null;
                          },
                          controller: _nameController,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.blueAccent,
                          ),
                          decoration: InputDecoration(
                              prefixIcon: Icon(Icons.people),
                              hintText: "Chart Name",
                              border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey, width: 32.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.white, width: 32.0),
                              ))),
                    ),
                    Expanded(
                      child: SizedBox(
                        width: queryData.size.width,
                        child: ListView.builder(
                            itemBuilder: (context, index) => Container(
                                  decoration:
                                      BoxDecoration(color: colors[index % 2]),
                                  child: ListTile(
                                      leading: Icon(Icons.person_outline),
                                      title: Text(
                                          "Agent Group: ${getAgent(context, agents[index].agent_id)}"),
                                      subtitle: Text(
                                          "${agents[index].agent_struct['name']['value']}")),
                                ),
                            itemCount: agents.length),
                      ),
                    )
                  ],
                )),
            actions: <Widget>[
              FlatButton(
                child: Text('CREATE'),
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    setState(() {
                      this.inAsync = true;
                      chartCreation(context, agents, _nameController.text)
                          .then((value) => {
                                this.inAsync = false,
                                Scaffold.of(context).showSnackBar(SnackBar(
                                    content: Text(
                                        'Chart ${_nameController.text} added successfully'))),
                                setState(() {})
                              })
                          .catchError((err) => {
                                print(err.toString()),
                                this.inAsync = false,
                                Scaffold.of(context).showSnackBar(SnackBar(
                                    content: Text('${err.toString()}'))),
                                setState(() {})
                              });
                    });
                  }
                },
              ),
              FlatButton(
                child: Text('CANCEL'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        }),
      ),
    );
  }

  String getAgent(BuildContext context, dynamic id) {
    var agentGroups = Provider.of<AgentsManager>(context).agentsList;
    for (Agent agent in agentGroups) {
      print(agent.id);
      print(agent.id.runtimeType);
      if (agent.id == id) {
        return agent.program;
      }
    }
    return '';
  }

  // ignore: missing_return
  Future<Void> chartCreation(BuildContext context, List<DataPointAgent> agents,
      String chartName) async {
    GraphQLClient _client = GraphQLClient(
      cache: InMemoryCache(),
      link: new HttpLink(
          uri: Provider.of<AgentsManager>(context, listen: false).httpLink),
    );

    QueryOptions options = QueryOptions(
      documentNode: gql(AgentFetch().createChart),
      variables: <String, String>{"name": chartName},
    );

    QueryResult result = await _client.query(options);
    var chartID = result.data["createChart"]["chart"]["idxChart"];

    for (DataPointAgent agent in agents) {
      QueryOptions options = QueryOptions(
        documentNode: gql(AgentFetch().addChartDataPoint),
        variables: <String, String>{
          "idxDatapoint": agent.datapoint_id,
          "idxChart": chartID
        },
      );
      QueryResult result = await _client.query(options);
      print(
          "Datapoint ${result.data['createChartDataPoint']['chartDatapoint']['idxDatapoint']} was added to Chart ${result.data['createChartDataPoint']['chartDatapoint']['idxChart']} ");
    }
  }
}
