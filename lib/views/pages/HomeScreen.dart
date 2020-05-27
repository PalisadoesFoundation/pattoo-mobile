import 'package:flutter/material.dart';
import 'package:pattoomobile/models/view_models/home_screen_listview.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return AgentsList();
}
}
