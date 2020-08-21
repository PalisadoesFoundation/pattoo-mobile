import 'package:flutter/material.dart';
import 'package:pattoomobile/controllers/theme_manager.dart';
import 'package:provider/provider.dart';
import 'package:pattoomobile/views/pages/ListScreen.dart';

Widget agentButton(BuildContext context, agent) {
  MediaQueryData queryData;
  queryData = MediaQuery.of(context);

  return InkWell(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => List(agent),
        ),
      );
    },
    child: Align(
      child: Container(
        width: queryData.size.shortestSide,
        child: Card(
            margin: queryData.orientation == Orientation.landscape
                ? EdgeInsets.only(
                    top: queryData.size.longestSide * 0.017,
                    bottom: queryData.size.longestSide * 0.017,
                    left: queryData.size.shortestSide * 0.017,
                    right: queryData.size.shortestSide * 0.017)
                : EdgeInsets.only(
                    top: queryData.size.longestSide * 0.007,
                    bottom: queryData.size.longestSide * 0.007,
                    left: queryData.size.shortestSide * 0.017,
                    right: queryData.size.shortestSide * 0.017),
            elevation: 10,
            shape: new RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(queryData.size.shortestSide * 0.015)),
            color: Provider.of<ThemeManager>(context).themeData.backgroundColor,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: queryData.size.longestSide * 0.02,
                  ),
                  FittedBox(
                    fit: BoxFit.contain,
                    child: Image(
                        image: AssetImage("images/technical-support.png"),
                        height: queryData.size.longestSide * 0.14,
                        width: queryData.size.longestSide * 0.14),
                  ),
                  SizedBox(height: queryData.size.longestSide * 0.01),
                  SizedBox(
                    width: queryData.size.shortestSide * 0.5,
                    child: Wrap(direction: Axis.horizontal, children: <Widget>[
                      Text(agent.program,
                          style: TextStyle(
                              fontSize:
                                  queryData.orientation == Orientation.portrait
                                      ? queryData.size.shortestSide * 0.032
                                      : queryData.size.shortestSide * 0.032,
                              color: Colors.white),
                          textAlign: TextAlign.center)
                    ]),
                  ),
                ])),
      ),
    ),
  );
}

class agentoption extends StatefulWidget {
  @override
  _agentoptionState createState() => _agentoptionState();
}

class _agentoptionState extends State<agentoption> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
