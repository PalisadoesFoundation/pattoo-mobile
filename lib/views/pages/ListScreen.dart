import 'package:flutter/material.dart';
import 'package:pattoomobile/models/view_models/tileItem.dart';
import 'package:pattoomobile/widgets/circleMenu.dart';
import 'package:provider/provider.dart';
import 'package:pattoomobile/controllers/theme_manager.dart' ;
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
        backgroundColor: Provider.of<ThemeManager>(context,listen: false).themeData.backgroundColor,
        actions: <Widget>[Menu(),],
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