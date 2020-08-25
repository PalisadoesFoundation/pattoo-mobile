import 'package:flutter/material.dart';
import 'package:pattoomobile/controllers/userState.dart';
import 'package:pattoomobile/util/validator.dart';
import 'package:pattoomobile/models/view_models/login_form_model.dart';
import 'package:pattoomobile/widgets/emailLogin.dart';
import 'package:provider/provider.dart';
import 'package:pattoomobile/controllers/theme_manager.dart';
import 'package:pattoomobile/utils/app_themes.dart';
import 'package:pattoomobile/models/timestamp.dart';

class LoginForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  LoginFormModel userLogin = new LoginFormModel();

  TimeStamp time = new TimeStamp(timestamp: 1591211730580, value: 10);
  String _errorMessage;
  final _formKey = new GlobalKey<FormState>();
  bool _isLoading;
  bool _isLoginForm;
  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    _errorMessage = "";
    _isLoading = false;
    _isLoginForm = true;
    super.initState();
  }

  get validateAndSubmit => null;

  // Check if form is valid before perform login or signup
  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void resetForm() {
    _formKey.currentState.reset();
    _errorMessage = "";
  }

  Widget _showCircularProgress() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return Container(
      height: 0.0,
      width: 0.0,
    );
  }

  Widget _showForm(BuildContext context) {
    return new Container(
        padding: EdgeInsets.all(16.0),
        child: new Form(
          key: _formKey,
          child: new ListView(
            shrinkWrap: true,
            children: <Widget>[
              showLogo(context),
              showUsernameInput(),
              showPasswordInput(),
              showPrimaryButton(context),
              showErrorMessage(),
            ],
          ),
        ));
  }

  Widget showErrorMessage() {
    if (_errorMessage.length > 0 && _errorMessage != null) {
      return new Text(
        _errorMessage,
        style: TextStyle(
            fontSize: 13.0,
            color: Colors.red,
            height: 1.0,
            fontWeight: FontWeight.w300),
      );
    } else {
      return new Container(
        height: 0.0,
      );
    }
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

  Widget showUsernameInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 100.0, 0.0, 0.0),
      child: new TextFormField(
        controller: _controller,
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'Username',
            icon: new Icon(
              Icons.person,
            )),
        validator: validateEmail,
        onSaved: (value) => this.userLogin.username = value.trim(),
      ),
    );
  }

  Widget showPasswordInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        obscureText: true,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'Password',
            icon: new Icon(
              Icons.lock,
            )),
        validator: FieldValidator.validatePassword,
        onSaved: (value) => this.userLogin.password = value.trim(),
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
            Provider.of<UserState>(context, listen: false)
                .setDisplayName(this._controller.text);
            Navigator.pushReplacementNamed(context, '/HomeScreen');
          }
        },
        child: const Text('Login',
            style: TextStyle(fontSize: 20, color: Colors.white)),
      ),
    );
  }

  //Regular Expression Validation
  String validateEmail(String value) {
    if (value == '' || value == null)
      return 'Field cannot be blank!';
    else
      return null;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: Stack(
      children: <Widget>[
        _showForm(context),
        _showCircularProgress(),
      ],
    ));
  }
}
