import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

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
          height: queryData.size.height * 0.09,
          child:
              Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
            AnimatedOpacity(
              opacity: visible ? 1.0 : 0.0,
              duration: Duration(milliseconds: 500),
              child: SizedBox(
                height: queryData.size.height * 0.09,
                child: Image(image: AssetImage("images/finger.png")),
              ),
            )
          ]),
        ),
        SizedBox(
            height: queryData.size.height * 0.35,
            child: Image(
              image: AssetImage("images/support.png"),
            )),
        SizedBox(
          height: queryData.size.height * 0.05,
        ),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
              style: DefaultTextStyle.of(context).style,
              children: <TextSpan>[
                TextSpan(
                    text:
                        "Currently there is no Pattoo api linked to the application \n\n",
                    style: TextStyle(
                        fontFamily: 'Quicksand',
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                        decoration: TextDecoration.none)),
                TextSpan(
                    children: <TextSpan>[
                      TextSpan(text: "Please go to "),
                      TextSpan(
                          text: "Settings ",
                          recognizer: new TapGestureRecognizer()
                            ..onTap = () {
                              setState(() {
                                visible = !visible;
                              });
                            },
                          style: TextStyle(
                              decoration: TextDecoration.none,
                              color: Colors.blue[400],
                              decorationColor: Colors.red[100])),
                      TextSpan(text: "to start linking")
                    ],
                    style: TextStyle(
                        fontFamily: 'Quicksand',
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                        decoration: TextDecoration.none,
                        decorationColor: Colors.red[100]))
              ]),
        ),
      ],
    ));
  }
}
