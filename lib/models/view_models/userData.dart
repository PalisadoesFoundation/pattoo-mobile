import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:pattoomobile/controllers/userState.dart';
import 'package:pattoomobile/models/view_models/user.dart';
import 'package:provider/provider.dart';

void main() => runApp(DataDisplay());

class DataDisplay extends StatelessWidget {

  @override

  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {



  @override
  _MyHomePageState createState() => _MyHomePageState();
}



class _MyHomePageState extends State<MyHomePage> {

  //String cursor = ""; idk why this is here yet
  //ScrollController _scrollController = new ScrollController(); idk why this is here yet


  List<String> tempList = [
    "first element",
    "second element",
    "third element",
    "fifth element",
    "example 6",
    "example 7",
    "example 8",
  ];

  @override
  Widget build(BuildContext context) {

    final userState = Provider.of<UserState>(context);

    return Scaffold(
      appBar:AppBar(
        title: Text(
          'My Favourites',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24.0,
          ),
        ),
      ),
      body: Center(
        child: ReorderableListView(
          children: List.generate(tempList.length, (index) {
            return Card(
              margin: EdgeInsets.only(left: 5, top: 10, right: 5, bottom: 10),
              elevation: 10,
              key: UniqueKey(),
              child: ListTile(
                title: Text(tempList[index]),
                subtitle: Text('details about chart'),
              ),
            );
          }),
          onReorder: (int oldIndex, int newIndex) {
            setState(() {
              if (newIndex > oldIndex) {
                newIndex -= 1;
              }
              final String newString = tempList.removeAt(oldIndex);
              tempList.insert(newIndex, newString);
            });
          },
        ),
      ),

    );
  }
}
