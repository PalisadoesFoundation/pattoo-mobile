import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:pattoomobile/api/api.dart';
import 'package:pattoomobile/controllers/agent_controller.dart';
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

  // The Endpoint URL Validator variables

  final formKey = GlobalKey<FormState>();
  final urlTextController = TextEditingController();

  String dropdownValue = 'HTTP';
  String dropdownValue2 = '/pattoo/api/v1/web/graphql';
  bool inAsyncCall = false;
  bool isInvalidURL = false;
  Widget icon = Icon(
    Icons.assessment,
    color: Colors.grey,
    size: 25.0,
  );


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
          validateUser;
        },
        child: const Text('Login',
            style: TextStyle(fontSize: 20, color: Colors.white)),
      ),
    );
  }



//  Future<void> _firstURL() async {
//    SharedPreferences prefs = await SharedPreferences.getInstance();
//    bool isFirstLoaded = prefs.getBool(keyIsFirstLoaded);
//    if (isFirstLoaded == null)
//    {
//      return showDialog<void>(
//        context: context,
//        barrierDismissible: false, // user must tap button!
//        builder: (BuildContext context) {
//          return AlertDialog(
//
//            title: Text('Enter desired url'),
//            content: SingleChildScrollView(
//              child: ListBody(
//                children: <Widget>[
//                  TextField(
//                    //controller: email,
//                    decoration: InputDecoration(
//                      icon: Icon(Icons.insert_chart),
//                      labelText: 'Pattoo Url',
//                    ),
//                  ),
//                ],
//              ),
//            ),
//            actions: <Widget>[
//              Column(
//                mainAxisAlignment: MainAxisAlignment.center,
//                children: <Widget>[
//                  RaisedButton(
//                    onPressed: ()
//                    {
//                      //submit url
//                    },
//                    textColor: Colors.white,
//                    color: Colors.blueAccent,
//                    padding: const EdgeInsets.all(8.0),
//                    child: new Text(
//                      "Submit",
//                    ),
//                  ),
//                  FlatButton(
//                    child: Text('Close'),
//                    onPressed: () {
//
//                      Navigator.of(context).pop();
//                      prefs.setBool(keyIsFirstLoaded, false);
//                    },),
//                ],
//              )
//            ],
//          );
//        },
//      );
//    }
//  }


  Future<void> _firstPopUp() async{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool isFirstLoaded = prefs.getBool(keyIsFirstLoaded);
      if (isFirstLoaded == null) {

      }
    }


  Future<void> _urlPopUp() async{
    var queryData = MediaQuery.of(context);
    return showGeneralDialog(

        context: context,
        barrierDismissible: true,
        barrierLabel: MaterialLocalizations.of(context)
            .modalBarrierDismissLabel,
        barrierColor: Colors.black45,
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (BuildContext buildContext,
            Animation animation,
            Animation secondaryAnimation) {
          return Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(

              child: Container(

                  width: MediaQuery.of(context).size.width - 10,
                  height: MediaQuery.of(context).size.height -500,
                  padding: EdgeInsets.all(20),
                  color: Colors.white,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        child: SingleChildScrollView(
                            child: Form(

                              child: Container(
                                  child:
                                  Row(
                                    children: <Widget>[
                                      SizedBox(
                                        width: 15,
                                      ),
                                      new Flexible(
                                        child: icon,
                                      ),
                                      SizedBox(
                                        width: 38,
                                      ),
                                      SizedBox(
                                        width: queryData.size.width * 0.45,
                                        child: TextFormField(
                                          //controller: urlTextController,
                                          decoration: const InputDecoration(
                                            hintText: "Pattoo API URL",
                                            helperText: "eg. Calico.palisadoes.org",
                                          ),
                                          //validator: validate,
                                        ),
                                      ),
                                      SizedBox(
                                        width: queryData.size.width * 0.05,
                                      ),
                                      new DropdownButton<String>(
                                        value: dropdownValue,
                                        icon: Icon(Icons.arrow_downward),
                                        iconSize: 24,
                                        elevation: 16,
                                        underline: Container(
                                          height: 2,
                                          color: Provider.of<ThemeManager>(context)
                                              .themeData
                                              .primaryTextTheme
                                              .headline6
                                              .color,
                                        ),
                                        onChanged: (String newValue) {
                                          setState(() {
                                            dropdownValue = newValue;
                                          });
                                        },
                                        items: <String>[
                                          'HTTP',
                                          'HTTPS',
                                        ].map<DropdownMenuItem<String>>((String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                      ),
                                    ],
                                  ),
                              ),


                            )
                        ),

                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Padding(
                             padding: const EdgeInsets.all(20.0),
                             child: RaisedButton(
                               color: Colors.blueAccent,
                               onPressed: (){},
                               textColor: Colors.white,
                               padding: const EdgeInsets.all(0.0),
                               child: Text('Submit'),
                             ),
                           ),
                          Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: FlatButton(
                          color: Colors.transparent,
                          onPressed: (){
                            Navigator.pop(context);
                      },
                          textColor: Colors.blueAccent,
                          padding: const EdgeInsets.all(0.0),
                          child: Text('Close'),
                          )
                          ),
                        ],
                      ),

                    ],
                  )

              ),
            ),
          );
        });

  }


  Future<void> _enterURL() async {
    var queryData = MediaQuery.of(context);
    var screenW = queryData.size.width;
//    SharedPreferences prefs = await SharedPreferences.getInstance();
//    bool isFirstLoaded = prefs.getBool(keyIsFirstLoaded);
//    if (isFirstLoaded != null)
//      {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter desired url'),
          content: Container(
            width: screenW,
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

        );
      },
    );
    //}
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
    //Future.delayed(Duration.zero, () => _firstURL());
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
                _urlPopUp();
                //_enterURL();
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




  // Authentication  Code for

  //Authentication
  void validateUser() async{

    var userEmail = username.text;
    var userPassword = password.text;

    print(userEmail);
    print(userPassword);


    if(!Provider.of<AgentsManager>(context, listen: false).loaded){
      setState(() {
        _errorMessage = "Please enter the server url first";
      });
      _enterURL();
    }else{

      setState(() {
        this.inAsyncCall = true;
      });

      QueryOptions options = QueryOptions(
        documentNode: gql(AgentFetch().Authentication),
        variables: <String, String>{
          'username': userEmail,
          'password': userPassword,
        },
      );

      GraphQLClient _client = GraphQLClient(
        cache: InMemoryCache(),
        link: new HttpLink(uri: Provider.of<AgentsManager>(context, listen: false).loaded
            ? Provider.of<AgentsManager>(context, listen: false).link + "/graphql"
            :"none"),
      );

      QueryResult result = await _client.query(options);
      if (result.loading && result.data == null) {
        print("loading");
      }
      if(!result.hasException){
        setState(() {
          _errorMessage = "";
        });
        print("Query data ${result.data["authenticate"]}");

        if(result.data["authenticate"][0]["id"] == null){
          _notInSystem();
        }else{
          String userId =result.data["authenticate"][0]["id"];
          print("User ID is ${userId}");
          // Navigator.pushReplacementNamed(context, '/HomeScreen');
        }
        // give welcome message?
        // Then navigate close and navigate to home

      }else{
        print(result.exception.toString());
        //Message user not in system
      }
    }
  }

  void _notInSystem(){
    setState(() {
      username.clear();
      password.clear();
      _errorMessage = "Invalid user credentials entered. Try Again!";
    });
  }


  // ===============================
  //   Url Validator pop up code
  // ===============================


  Future Validate_pattoo(String text) async {
    setState(() {
      this.inAsyncCall = true;
    });
    String uri =
        "${dropdownValue.toLowerCase()}://${text.trim()}/pattoo/api/v1/web/graphql";
    QueryOptions options = QueryOptions(
      documentNode: gql(AgentFetch().getAllAgents),
      variables: <String, String>{
        // set cursor to null so as to start at the beginning
        // 'cursor': 10
      },
    );
    GraphQLClient _client = GraphQLClient(
      cache: InMemoryCache(),
      link: new HttpLink(uri: uri),
    );
    QueryResult result = await _client.query(options);
    print("we here");
    if (result.loading && result.data == null) {
      print("loading");
    }
    if (result.hasException) {
      print("error");
      setState(() {
        this.isInvalidURL = false;
        icon = Icon(
          Icons.error,
          color: Colors.red,
          size: 25.0,
        );
        this.inAsyncCall = false;
      });
    }
    if (!result.hasException) {
      setState(() {
        icon = Icon(
          Icons.check_circle_outline,
          color: Colors.green,
          size: 25.0,
        );
        this.isInvalidURL = true;
        this.inAsyncCall = false;
      });
    }

    setState(() {
      this.inAsyncCall = false;
    });
  }


  String validate(String text) {
    print(isInvalidURL);
    if (isInvalidURL) {
      return null;
    } else {
      return "Invalid API URL";
    }
  }

  //function to validate url input
  void _submit() async {
    var _source = urlTextController.text;
    await Validate_pattoo(_source);
    print("validation complete");
    print(formKey.currentState.validate());
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      print(_source);
      String uri = "${dropdownValue.toLowerCase()}://${_source.trim()}/pattoo/api/v1/web";
      Provider.of<AgentsManager>(context, listen: false).setLink(uri);
      Provider.of<AgentsManager>(context, listen: false).loaded = true;
      print(Provider.of<AgentsManager>(context, listen: false).loaded);
      print(Provider.of<AgentsManager>(context, listen: false).link);
      Navigator.of(context).pop();
    }
  }

}