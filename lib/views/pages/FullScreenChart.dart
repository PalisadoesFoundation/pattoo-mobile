import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pattoomobile/chartdir/chart_util.dart';

class FullScreenChart extends StatefulWidget {
  final Widget child;
  FullScreenChart({Key key, Widget this.child}) : super(key: key);

  @override
  _fullScreenChartState createState() => _fullScreenChartState(child);
}

class _fullScreenChartState extends State<FullScreenChart> {
  Widget child;
  _fullScreenChartState(this.child);
  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Scaffold(
        body: Column(children: <Widget>[
      Expanded(
        child: child,
      ),
      Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
        IconButton(
          icon: Icon(Icons.zoom_out_map),
          onPressed: () {
            SystemChrome.setPreferredOrientations([
              DeviceOrientation.portraitUp,
              DeviceOrientation.portraitDown,
            ]);
            Navigator.pop(context);
          },
        )
      ]),
    ]));
  }
}
