import 'package:flutter/material.dart';
import 'package:pattoomobile/controllers/theme_manager.dart';
import 'package:provider/provider.dart';
import 'package:pattoomobile/views/pages/ListScreen.dart';

Widget agentButton(BuildContext context, agent) {
  MediaQueryData queryData;
  queryData = MediaQuery.of(context);

  return Padding(
      padding: EdgeInsets.fromLTRB(10.0, 12.0, 10.0, 10.0),
      child: ButtonTheme(
        height: queryData.size.height * 0.04,
        minWidth: queryData.size.width * 0.1,
        child: RaisedButton(
            elevation: 5.0,
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0)),
            color: Provider.of<ThemeManager>(context).themeData.backgroundColor,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => List(agent),
                ),
              );
            },
            child: new Center(
              child: Column(children: <Widget>[
                SizedBox(
                  height: queryData.size.height * 0.02,
                ),
                FittedBox(
                  fit: BoxFit.contain,
                  child: Image(
                    image: AssetImage("images/technical-support.png"),
                    height: queryData.size.height * 0.14,
                    width: queryData.size.height * 0.14,
                  ),
                ),
                SizedBox(height: queryData.size.height * 0.01),
                SizedBox(
                    height: queryData.size.height * 0.05,
                    child: Wrap(direction: Axis.horizontal, children: <Widget>[
                      Text(agent.program,
                          style: TextStyle(
                              fontSize: queryData.size.width * 0.032,
                              color: Colors.white),
                          textAlign: TextAlign.center)
                    ])),
              ]),
            )),
      ));
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
