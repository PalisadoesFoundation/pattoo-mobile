import 'package:flutter/material.dart';
import 'package:pattoomobile/controllers/userState.dart';
import 'package:pattoomobile/util/validator.dart';
import 'package:pattoomobile/models/view_models/login_form_model.dart';
import 'package:pattoomobile/widgets/emailLogin.dart';
import 'package:provider/provider.dart';
import 'package:pattoomobile/controllers/theme_manager.dart';
import 'package:pattoomobile/utils/app_themes.dart';
import 'package:pattoomobile/models/timestamp.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();

  final keyIsFirstLoaded = 'is_first_loaded';

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
        controller: username,
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'Email',
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
        controller: password,
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
      padding: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
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

  Widget urlInput(BuildContext context)
  {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 40.0, 0.0, 0.0),
      child: Center(
        child:
        GestureDetector(
            child: Text("Change url", style: TextStyle(decoration: TextDecoration.underline, color: Colors.blue, fontStyle: FontStyle.italic)),
            onTap: () {
              _enterURL();
            }
        ),
      ),
    );
  }

  Future<void> _firstURL() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstLoaded = prefs.getBool(keyIsFirstLoaded);
    if (isFirstLoaded == null)
    {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(

            title: Text('Enter desired url'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  TextField(
                    //controller: email,
                    decoration: InputDecoration(
                      icon: Icon(Icons.insert_chart),
                      labelText: 'Pattoo Url',
                    ),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    onPressed: ()
                    {
                      //submit url
                    },
                    textColor: Colors.white,
                    color: Colors.blueAccent,
                    padding: const EdgeInsets.all(8.0),
                    child: new Text(
                      "Submit",
                    ),
                  ),
                  FlatButton(
                    child: Text('Close'),
                    onPressed: () {

                      Navigator.of(context).pop();
                      prefs.setBool(keyIsFirstLoaded, false);
                    },),
                ],
              )
            ],
          );
        },
      );
    }
  }

  Future<void> _enterURL() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstLoaded = prefs.getBool(keyIsFirstLoaded);
    if (isFirstLoaded != null)
      {
        return showDialog<void>(
          context: context,
          barrierDismissible: false, // user must tap button!
          builder: (BuildContext context) {
            return AlertDialog(

              title: Text('Enter desired url'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    TextField(
                      //controller: email,
                      decoration: InputDecoration(
                        icon: Icon(Icons.insert_chart),
                        labelText: 'Pattoo Url',
                      ),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    RaisedButton(
                      onPressed: ()
                      {
                        //submit url
                      },
                      textColor: Colors.white,
                      color: Colors.blueAccent,
                      padding: const EdgeInsets.all(8.0),
                      child: new Text(
                        "Submit",
                      ),
                    ),
                    FlatButton(
                      child: Text('Close'),
                      onPressed: () {

                        Navigator.of(context).pop();
                        prefs.setBool(keyIsFirstLoaded, false);
                      },),
                  ],
                )
              ],
            );
          },
        );
      }
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
    Future.delayed(Duration.zero, () => _firstURL());
    return new Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
            icon: new Icon(
        Icons.build,
              size: 35,
              color: Colors.blueAccent,
      ),
            onPressed: () {
              _enterURL();
            },),


        ],
      ),
        body: Stack(
      children: <Widget>[
        _showForm(context),
        _showCircularProgress(),

      ],
    ));
  }
}
