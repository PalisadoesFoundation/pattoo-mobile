import 'package:flutter/material.dart';
import 'package:pattoomobile/models/view_models/table_tile.dart';

class List extends StatefulWidget {

  @override
  _ListState createState() => _ListState(5);
}

class _ListState extends State<List> {
  final int index;

  _ListState(this.index);
    tileTable tile = new tileTable();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reports'),
      ),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text('Title'),
              subtitle: Text('Description of chart'),
              leading: Image(image: NetworkImage('https://www.fusioncharts.com/blog/wp-content/uploads/2013/06/Line-chart.png'),),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {},
            ),
          );
        },
      ),
    );
  }
}
