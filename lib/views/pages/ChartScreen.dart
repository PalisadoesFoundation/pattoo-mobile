import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart';
import 'package:pattoomobile/chartdir/chart_util.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Chart Exploration',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ChartPage(title: 'I am a chart'),
    );
  }
}

class ChartPage extends StatefulWidget {
  ChartPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ChartPageState createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  List<Series> vibrationData;

  @override
  Widget build(BuildContext context) {

    ChartUtil().getChartData().then((vibrationData) {
      setState(() {
        this.vibrationData = vibrationData;
      });
    });

    return Scaffold(

      appBar: AppBar(
        title: Text("Title of Chart",
          style: TextStyle(
            color: Colors.black,
          ),),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
      ),
      body:Container(
        height: 1000.0,
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Center(
                child: vibrationData != null
                    ? FractionallySizedBox(
                  child: TimeSeriesChart(
                    vibrationData,
                    defaultRenderer: new LineRendererConfig(
                        includeArea: true, stacked: true),
                    animate: false,
                    domainAxis:
                    new DateTimeAxisSpec(renderSpec: NoneRenderSpec()),
                  ),
                  heightFactor: .5,
                )
                    : CircularProgressIndicator(),
              ),
            ),
            Container(

              child: Expanded(
                  child:  ListView(
                    //scrollDirection: Axis.horizontal,
                    children: <Widget>[
                      RaisedButton(
                        color: Colors.blue,
                        textColor: Colors.white,
                        onPressed: () {},
                        child: const Text('Hour', style: TextStyle(fontSize: 20)),
                      ),
                      RaisedButton(
                        color: Colors.blue,
                        textColor: Colors.white,
                        onPressed: () {},
                        child: const Text('Daily', style: TextStyle(fontSize: 20)),
                      ),
                      RaisedButton(
                        color: Colors.blue,
                        textColor: Colors.white,
                        onPressed: () {},
                        child: const Text('Monthly', style: TextStyle(fontSize: 20)),
                      ),
                      RaisedButton(
                        color: Colors.blue,
                        textColor: Colors.white,
                        onPressed: () {},
                        child: const Text('Half-Yearly', style: TextStyle(fontSize: 20)),
                      ),
                      RaisedButton(
                        color: Colors.blue,
                        textColor: Colors.white,
                        onPressed: () {},
                        child: const Text('Yearly', style: TextStyle(fontSize: 20)),
                      ),
                      const SizedBox(height: 30),
                    ],
                  )
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0, // this will be set when a new tab is tapped
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.home),
            title: new Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.favorite),
            title: new Text('Favorites'),
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              title: Text('Settings')
          )
        ],
      ),
    );
  }
}
