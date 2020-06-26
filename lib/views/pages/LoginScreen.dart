import 'package:flutter/material.dart';
import 'package:pattoomobile/widgets/LoginForm.dart';

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
