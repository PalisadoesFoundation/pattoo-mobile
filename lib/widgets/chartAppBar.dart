import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:pattoomobile/api/api.dart';
import 'package:pattoomobile/controllers/agent_controller.dart';
import 'package:pattoomobile/models/chart.dart';
import 'package:provider/provider.dart';

class ChartAppBar extends StatefulWidget implements PreferredSizeWidget {
  final Chart chart;
  ChartAppBar({Key key, @required this.chart})
      : preferredSize = Size.fromHeight(kToolbarHeight),
        super(key: key);
  @override
  final Size preferredSize; // default is 56.0
  @override
  _ChartAppBarState createState() => _ChartAppBarState(chart: this.chart);
}

class _ChartAppBarState extends State<ChartAppBar> {
  final Chart chart;

  _ChartAppBarState({@required this.chart});
  static TextEditingController _controller = TextEditingController();
  static GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  static TextField _renameField = TextField(
    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    controller: _controller,
  );
  @override
  Widget build(BuildContext context) {
    String _title = chart.name;

    bool _renaming = false;

    return Container(
      child: StatefulBuilder(builder: (context, updateState) {
        return AppBar(
          actions: _renaming
              ? <Widget>[
                  IconButton(
                    icon: Icon(Icons.check),
                    onPressed: () {
                      this.renameChart(chart, _controller.text).then((value) {
                        _title = value;
                        _renaming = false;
                        updateState(() {});
                      });
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.cancel),
                    onPressed: () {
                      updateState(() {
                        _renaming = false;
                      });
                    },
                  )
                ]
              : <Widget>[
                  IconButton(
                    icon: Icon(Icons.create),
                    onPressed: () {
                      updateState(() {
                        _renaming = true;
                      });
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {},
                  )
                ],
          title: _renaming
              ? Form(key: _formKey, child: _renameField)
              : FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text(_title,
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold))),
          elevation: 0.0,
        );
      }),
    );
  }

  Future renameChart(Chart chart, String newName) async {
    String chartID = chart.idxChart;
    QueryOptions options = QueryOptions(
        documentNode: gql(AgentFetch().modifyChartNamne),
        variables: {"idxChart": chartID, "name": newName});
    GraphQLClient _client = GraphQLClient(
      cache: InMemoryCache(),
      link: new HttpLink(
          uri: Provider.of<AgentsManager>(context, listen: false).httpLink +
              "/graphql"),
    );
    QueryResult result = await _client.query(options);
    return result.data["updateChart"]["chart"]["name"];
  }
}
