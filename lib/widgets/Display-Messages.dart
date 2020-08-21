import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pattoomobile/controllers/theme_manager.dart';
import 'package:pattoomobile/utils/app_themes.dart';
import 'package:pattoomobile/views/pages/SettingsScreen.dart';
import 'package:provider/provider.dart';

class DisplayMessage extends StatefulWidget {
  @override
  _DisplayMessageState createState() => _DisplayMessageState();
}

class _DisplayMessageState extends State<DisplayMessage> {
  bool visible = false;
  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          height: queryData.size.longestSide * 0.09,
        ),
        SizedBox(
            height: queryData.size.longestSide * 0.35,
            child: Lottie.asset("assets/no-data.json")),
        SizedBox(
          height: queryData.size.longestSide * 0.05,
        ),
        SizedBox(
          width: queryData.size.shortestSide * 0.85,
          child: Wrap(direction: Axis.horizontal, children: <Widget>[
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                  style: DefaultTextStyle.of(context).style,
                  children: <TextSpan>[
                    TextSpan(
                        text:
                            "There is no Patto API connected to the Application\n\n",
                        style: TextStyle(
                            fontSize: queryData.size.shortestSide * 0.06,
                            fontWeight: FontWeight.bold,
                            color: Provider.of<ThemeManager>(context)
                                .themeData
                                .primaryTextTheme
                                .headline6
                                .color,
                            decoration: TextDecoration.none)),
                    TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                              text:
                                  "Please go to Settings and connect to an existing Pattoo API",
                              style: TextStyle(
                                  fontSize: queryData.size.width * 0.06,
                                  decoration: TextDecoration.none,
                                  color: Provider.of<ThemeManager>(context)
                                      .themeData
                                      .primaryTextTheme
                                      .headline6
                                      .color,
                                  decorationColor: Colors.red[100])),
                        ],
                        style: TextStyle(
                            fontSize: queryData.size.width * 0.06,
                            fontWeight: FontWeight.bold,
                            color: Provider.of<ThemeManager>(context)
                                .themeData
                                .primaryTextTheme
                                .headline6
                                .color,
                            decoration: TextDecoration.none,
                            decorationColor: Colors.red[100]))
                  ]),
            ),
          ]),
        ),
        SizedBox(
          height: queryData.size.height * 0.063,
        ),
      ],
    ));
  }
}
