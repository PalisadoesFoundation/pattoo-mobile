import 'package:flutter/material.dart';
import 'package:pattoomobile/controllers/userState.dart';
import 'package:pattoomobile/util/validator.dart';
import 'package:pattoomobile/models/view_models/login_form_model.dart';
import 'package:pattoomobile/widgets/emailLogin.dart';
import 'package:provider/provider.dart';
import 'package:pattoomobile/controllers/theme_manager.dart';
import 'package:pattoomobile/utils/app_themes.dart';
import 'package:pattoomobile/models/timestamp.dart';

class ContinueWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _ContinueWidgetState();
}

class _ContinueWidgetState extends State<ContinueWidget> {

  final _formKey = new GlobalKey<FormState>();
  @override



  Widget _showForm(BuildContext context) {
    return new Container(
        padding: EdgeInsets.all(16.0),
        child: new Form(
          key: _formKey,
          child: new ListView(
            shrinkWrap: true,
            children: <Widget>[
              showLogo(context),
              SizedBox(height: 90),
              showPrimaryButton(context),
            ],
          ),
        ));
  }


  Widget showLogo(BuildContext context) {
    MediaQueryData queryData = MediaQuery.of(context);

    AppTheme theme = Provider.of<ThemeManager>(context).getTheme();

    var logo = theme == AppTheme.Light
        ? 'images/pattoo-light.png'
        : 'images/pattoo-dark.png';
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 70.0, 0.0, 0.0),
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: queryData.size.shortestSide * 0.28,
        child: Image.asset(logo),
      ),
    );
  }

  Widget showPrimaryButton(BuildContext context) {
    MediaQueryData queryData = MediaQuery.of(context);
    return new Padding(
      padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
      child: RaisedButton(
        elevation: 5.0,
        shape: new RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(queryData.size.shortestSide * 0.015)),
        onPressed: () {
          if (_formKey.currentState.validate()) {
            Navigator.pushReplacementNamed(context, '/HomeScreen');
          }
        },
        child: const Text('Continue',
            style: TextStyle(fontSize: 20, color: Colors.white)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: Stack(
          children: <Widget>[
            _showForm(context),
          ],
        ));
  }
}
