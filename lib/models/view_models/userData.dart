import 'package:flutter/material.dart';
import 'package:pattoomobile/controllers/userState.dart';
import 'package:provider/provider.dart';

void main() => runApp(DataDisplay());

class DataDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}

class ListPage extends StatefulWidget {


  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  List<String> myCustomList = [
    //This is where query data would go
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
      appBar: AppBar(
        title: Text(
        '${userState.getUserName}s Favourites',
        style: TextStyle(
        color: Colors.white,
        fontSize: 24.0,
        ),
          ),
      ),
      body: Center(
        child: ReorderableListView(
          children: List.generate(myCustomList.length, (index) {
            return ListTile(
              key: UniqueKey(),
              title: Text(myCustomList[index]),
            );
          }),
          onReorder: (int oldIndex, int newIndex) {
            setState(() {
              if (newIndex > oldIndex) {
                newIndex -= 1;
              }
              final String newString = myCustomList.removeAt(oldIndex);
              myCustomList.insert(newIndex, newString);
            });
          },
        ),
      ),
    );
  }
}