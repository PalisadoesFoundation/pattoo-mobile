import 'package:flutter/material.dart';

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

  Widget MIB_SNMPButton() {
    return new Padding(
      padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
      child: RaisedButton(
        elevation: 5.0,
        shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(30.0)),
        onPressed: () {},
        child: const Text('ifMIB SNMP Agent',
            style: TextStyle(fontSize: 20, color: Colors.white)),
      ),
    );
  }

  Widget AutonomousButton() {
    return new Padding(
      padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
      child: RaisedButton(
        elevation: 5.0,
        shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(30.0)),
        onPressed: () {},
        child: const Text('OS Autonomous Agent',
            style: TextStyle(fontSize: 20, color: Colors.white)),
      ),
    );
  }


  Widget SNMPButton() {
    return new Padding(
      padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
      child: RaisedButton(
        elevation: 5.0,
        shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(30.0)),
        onPressed: () {},
        child: const Text(
            'SNMP Agent', style: TextStyle(fontSize: 20, color: Colors.white)),
      ),
    );
  }
