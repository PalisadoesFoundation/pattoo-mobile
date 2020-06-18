import 'package:flutter/material.dart';
import 'package:pattoomobile/util/validator.dart';
import 'package:pattoomobile/models/view_models/login_form_model.dart';

class LoginForm extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => new _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = new GlobalKey<FormState>();

  LoginFormModel userLogin = new LoginFormModel();
  String _errorMessage;
  bool _isLoginForm;
  bool _isLoading;

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

  @override
  void initState() {
    _errorMessage = "";
    _isLoading = false;
    _isLoginForm = true;
    super.initState();
  }

  void resetForm() {
    _formKey.currentState.reset();
    _errorMessage = "";
  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(

        body: Stack(
          children: <Widget>[
            _showForm(),
            _showCircularProgress(),
          ],
        ));
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

  Widget _showForm() {
    return new Container(
        padding: EdgeInsets.all(16.0),
        child: new Form(
          key: _formKey,
          child: new ListView(
            shrinkWrap: true,
            children: <Widget>[
              showLogo(),
              showEmailInput(),
              showPasswordInput(),
              showPrimaryButton(),
              showSecondaryButton(),
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

  Widget showLogo() {
    return new Hero(
      tag: 'hero',
      child: Padding(
        padding: EdgeInsets.fromLTRB(0.0, 70.0, 0.0, 0.0),
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 100.0,
          child: Image.asset('images/pattoo-rtd.png'),
        ),
      ),
    );
  }

  Widget showEmailInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 100.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'Email',
            icon: new Icon(
              Icons.mail,
              color: Colors.lightBlue,
            )),
        validator: FieldValidator.validateEmail,
        onSaved: (value) => this.userLogin.email = value.trim(),
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
              color: Colors.lightBlue,
            )),
        validator: FieldValidator.validatePassword,
        onSaved: (value) => this.userLogin.password = value.trim(),
      ),
    );
  }

  Widget showSecondaryButton() {
    return new FlatButton(
      child: Container(
        child: Align(
          alignment: Alignment.centerRight,
          child: new Text(
              'Forget Password?',
              style: new TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300,color: Colors.lightBlue)),
        ),
      ),
      onPressed: (){
        // Do something
      },);
  }
  Widget showPrimaryButton() {
    return new Padding(
      padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
      child: RaisedButton(
        elevation: 5.0,
        shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(30.0)),
        color: Colors.blue,
        onPressed: () {
          Navigator.pushNamed(context, '/HomeScreen');
        },
        child: const Text('Login', style: TextStyle(fontSize: 20, color: Colors.white)),
      ),
    );
  }
}