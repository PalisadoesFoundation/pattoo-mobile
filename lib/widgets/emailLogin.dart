/* import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pattoomobile/controllers/userState.dart';
import 'package:pattoomobile/models/view_models/login_form_model.dart';

class emailLogin extends StatefulWidget {
  @override
  _emailLoginState createState() => _emailLoginState();
}

class _emailLoginState extends State<emailLogin> {
  LoginFormModel userLogin = new LoginFormModel();

  @override
  Widget build(BuildContext context) {
    final userState = Provider.of<UserState>(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 100.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'Email here',
            icon: new Icon(
              Icons.mail,
            )),
        
        onChanged: (changed) => userState.setDisplayName(changed),
        validator: validateEmail,
        onSaved: (value) => this.userLogin.email = value.trim(),
      ),
    );
  }
}

//Regular Expression Validation
String validateEmail(String value) {
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = new RegExp(pattern);
  if (!regex.hasMatch(value))
    return 'Enter Valid Email';
  else
    return null;
}

 */
