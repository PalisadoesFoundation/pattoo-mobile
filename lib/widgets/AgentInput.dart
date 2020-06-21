import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// ignore: camel_case_types
class agentInput extends StatefulWidget {
  @override
  _agentInputState createState() => _agentInputState();
}

// ignore: camel_case_types
class _agentInputState extends State<agentInput> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 100.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'Email',
            icon: new Icon(
              Icons.multiline_chart,
              color: Colors.lightBlue,
            )),
      ),
    );
  }
}
