import 'package:flutter/material.dart';

class ListScreen extends StatelessWidget {
  final int index;

  ListScreen(this.index);

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
