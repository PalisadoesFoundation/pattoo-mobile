import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:pattoomobile/api/api.dart';
import 'package:pattoomobile/controllers/agent_controller.dart';
import 'package:pattoomobile/controllers/theme_manager.dart';
import 'package:provider/provider.dart';
import 'package:pattoomobile/util/AspectRation.dart';
import 'package:pattoomobile/util/validator.dart';
import 'DarkModeSwitch.dart';
import 'ShowFavSwitch.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class SettingsContainer extends StatefulWidget {
  @override
  _SettingsContainerState createState() => _SettingsContainerState();
}

class _SettingsContainerState extends State<SettingsContainer> {
  final formKey = GlobalKey<FormState>();
  final textController = TextEditingController();
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
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
        body: ModalProgressHUD(
      child: OrientationBuilder(
        builder: (context, orientation) {
          return _buildVerticalLayout(context);
        },
      ),
      inAsyncCall: inAsyncCall,
      opacity: 0.5,
      progressIndicator: CircularProgressIndicator(),
    ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2, // this will be set when a new tab is tapped
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.home),
            title: new Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.favorite),
            title: new Text('Favorites'),
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              title: Text('Settings')
          )
        ],
      ),
    );
  }

  Widget _buildVerticalLayout(context) {
    MediaQueryData queryData = MediaQuery.of(context);
    return new Scaffold(
      body: Container(
        height: SizeConfig.blockSizeVertical * 51,
        width: SizeConfig.blockSizeHorizontal * 220,
        color: Colors.transparent,
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Form(
              key: formKey,
              child: SizedBox(
                width: queryData.size.width * 0,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    DarkModeWidget(),
                    ShowFavWidget(),
                    Container(
                      child: Row(
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
                              controller: textController,
                              decoration: const InputDecoration(
                                hintText: "Pattoo API URL",
                                helperText: "eg. Calico.palisadoes.org",
                              ),
                              validator: validate,
                            ),
                          ),

                          // flex:1,
                          SizedBox(
                            width: queryData.size.width * 0.05,
                          ),
                          new DropdownButton<String>(
                            value: dropdownValue,
                            icon: Icon(Icons.arrow_downward),
                            iconSize: 24,
                            elevation: 16,
                            style: TextStyle(color: Colors.deepPurple),
                            underline: Container(
                              height: 2,
                              color: Colors.deepPurpleAccent,
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: RaisedButton(
                            color: Colors.blue,
                            splashColor: Colors.blueAccent,
                            onPressed: _submit,
                            textColor: Colors.white,
                            padding: const EdgeInsets.all(0.0),
                            child: Text('Submit'),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
       ),
    );
  }

  String validate(String text) {
    print(isInvalidURL);
    if (isInvalidURL) {
      return null;
    } else {
      return "Invalid API URL";
    }
  }

  Future Validate_pattoo(text) async {
    setState(() {
      this.inAsyncCall = true;
    });
    String uri =
        "${dropdownValue.toLowerCase()}://${text}/pattoo/api/v1/web/graphql";
    print(uri);
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

  void _submit() async {
    var _source = textController.text;
    await Validate_pattoo(_source);
    print(formKey.currentState.validate());
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      print(_source);
      String uri = "${dropdownValue.toLowerCase()}://${_source}/pattoo/api/v1/web/graphql";
      Provider.of<AgentsManager>(context,listen:false).setLink(uri);
      Provider.of<AgentsManager>(context,listen:false).loaded = true;
      print(Provider.of<AgentsManager>(context,listen:false).loaded);
      print(Provider.of<AgentsManager>(context,listen:false).link);
      Future.delayed(Duration(seconds: 3), () {
       Navigator.pushNamed(context, '/HomeScreen');
      });
    }
  }
}