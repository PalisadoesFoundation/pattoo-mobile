import 'package:flutter/material.dart';
import 'package:pattoomobile/controllers/agent_controller.dart';
import 'package:pattoomobile/widgets/LoginForm.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {

    return LoginForm();
  }
}
