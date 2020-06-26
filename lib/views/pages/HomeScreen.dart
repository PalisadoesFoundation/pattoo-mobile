import 'package:flutter/material.dart';
import 'package:pattoomobile/controllers/agent_controller.dart';
import 'package:pattoomobile/controllers/client_provider.dart';
import 'package:pattoomobile/widgets/AgentsList.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return ClientProvider(
        uri: Provider.of<AgentsManager>(context).loaded
            ? Provider.of<AgentsManager>(context).httpLink
            : "None",
        child: AgentsList());
  }
}
