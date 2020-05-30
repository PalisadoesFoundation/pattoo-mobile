import 'package:flutter/material.dart';
import 'package:pattoomobile/models/view_models/tileItem.dart';

class List extends StatefulWidget {

  @override
  _ListState createState() => _ListState(5);
}

class _ListState extends State<List> {
  final int index;

  _ListState(this.index);
  TileItem tile = new TileItem();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Text('Reports'),
        backgroundColor: Colors.blue,

        actions: <Widget>[
          SizedBox(height: 10),
          ClipOval(
            child: Material(
              color: Colors.white, // button color
              child: InkWell(
                splashColor: Colors.blueAccent, // inkwell color
                child: SizedBox(width: 56, height: 56, child: Icon(Icons.menu,
                  color: Colors.blue,)),
                onTap: () {},
              ),
            ),
          ),
        ],
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