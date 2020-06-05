import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsContainer extends StatefulWidget {

  @override
  _SettingsContainerState createState() => _SettingsContainerState();
}

class _SettingsContainerState extends State<SettingsContainer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OrientationBuilder(
        builder: (context, orientation) {
          return orientation == Orientation.portrait
              ? _buildVerticalLayout()
              : _buildHorizontalLayout();
        },
      ),
    );
  }
Widget _buildVerticalLayout()
{
  return Scaffold(
      body: Container(
      height: 500,
  color: Colors.transparent,
  child: new Container(
  margin: EdgeInsets.fromLTRB(20, 50, 20, 250),
  decoration: new BoxDecoration(
  color: Colors.white,
  borderRadius: new BorderRadius.only(
  topLeft: const Radius.circular(40.0),
  topRight: const Radius.circular(40.0),
  bottomLeft: const Radius.circular(40.0),
  bottomRight: const Radius.circular(40.0),
  ),
  boxShadow: [
  BoxShadow(
  color: Colors.grey.withOpacity(0.5),
spreadRadius: 5,
blurRadius: 7,
  offset: Offset(0, 3), // changes position of shadow
  ),
],
),
),
),
  );
}

Widget _buildHorizontalLayout() {
  return Scaffold(
    body: Container(
      height: MediaQuery.of(context).size.height * .7,
      width: MediaQuery.of(context).size.width * 1,
      color: Colors.transparent,
      child: new Container(
        margin: EdgeInsets.fromLTRB(10, 30, 10, 10),
        decoration: new BoxDecoration(
          color: Colors.white,
          borderRadius: new BorderRadius.only(
            topLeft: const Radius.circular(40.0),
            topRight: const Radius.circular(40.0),
            bottomLeft: const Radius.circular(40.0),
            bottomRight: const Radius.circular(40.0),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
      ),
    ),
  );
  }
}