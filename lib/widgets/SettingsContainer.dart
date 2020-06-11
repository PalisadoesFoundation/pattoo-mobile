import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:pattoomobile/controllers/theme_manager.dart';
import 'package:provider/provider.dart';
=======
import 'package:pattoomobile/util/AspectRation.dart';

import 'DarkModeSwitch.dart';
import 'ShowFavSwitch.dart';
>>>>>>> aab8f8c31b3339197d841daa41a1ff7594964a3b

class SettingsContainer extends StatefulWidget {

  @override
  _SettingsContainerState createState() => _SettingsContainerState();
}

class _SettingsContainerState extends State<SettingsContainer> {
  final formKey = GlobalKey<FormState>();
  String _email, _password;


  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: OrientationBuilder(
        builder: (context, orientation) {
          return orientation == Orientation.portrait
              ? _buildVerticalLayout()
              : _buildHorizontalLayout();
        },
      ),
    );
  }
  Widget _buildVerticalLayout()
  {
    return new Scaffold(

        body: Container(
          height: SizeConfig.blockSizeVertical * 51,
          width: SizeConfig.blockSizeHorizontal * 150,
          color: Colors.transparent,
          child: Card(
            elevation:5,
            margin: EdgeInsets.fromLTRB(20, 30, 20, 40),
            shape:RoundedRectangleBorder(
              borderRadius: new BorderRadius.only(
                topLeft: const Radius.circular(40.0),
                topRight: const Radius.circular(40.0),
                bottomLeft: const Radius.circular(40.0),
                bottomRight: const Radius.circular(40.0),
              ),

            ),
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    DarkModeWidget(),
                    ShowFavWidget(),
                    Container(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(15, 10, 20, 0),
                          child: new TextFormField(
                            decoration: InputDecoration(
                                labelText: 'Select Source',
                                icon: new Icon(
                                  Icons.assessment,
                                  color: Colors.grey,
                                )
                            ),
                            validator: (input) => input.length < 8 ? 'You need at least 8 characters' : null, //add validator for the type of data source
                            onSaved: (input) => _password = input,
                          ),

                        )
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

  Widget _buildHorizontalLayout() {
    return new Scaffold(

      body: Container(
<<<<<<< HEAD
      height: 500,
  color: Colors.transparent,
  child: new Container(
  margin: EdgeInsets.fromLTRB(20, 50, 20, 250),
  decoration: new BoxDecoration(
  color:  Provider.of<ThemeManager>(context,listen: false).themeData.backgroundColor,
  borderRadius: new BorderRadius.only(
  topLeft: const Radius.circular(40.0),
  topRight: const Radius.circular(40.0),
  bottomLeft: const Radius.circular(40.0),
  bottomRight: const Radius.circular(40.0),
  ),
  boxShadow: [
  BoxShadow(
  color: Colors.grey.withOpacity(0.5),
spreadRadius: 5,
blurRadius: 7,
  offset: Offset(0, 3), // changes position of shadow
  ),
],
),
),
),
  );
}

Widget _buildHorizontalLayout() {
  return Scaffold(
    body: Container(
      height: MediaQuery.of(context).size.height * .7,
      width: MediaQuery.of(context).size.width * 1,
      child: new Container(
        margin: EdgeInsets.fromLTRB(10, 30, 10, 10),
        decoration: new BoxDecoration(
          borderRadius: new BorderRadius.only(
            topLeft: const Radius.circular(40.0),
            topRight: const Radius.circular(40.0),
            bottomLeft: const Radius.circular(40.0),
            bottomRight: const Radius.circular(40.0),
          ),
          boxShadow: [
            BoxShadow(
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
=======
        height: SizeConfig.blockSizeVertical * 100,
        width: SizeConfig.blockSizeHorizontal * 150,
        color: Colors.transparent,
        child: Card(
          elevation:5,
          margin: EdgeInsets.fromLTRB(40, 10, 40, 0),
          shape:RoundedRectangleBorder(
            borderRadius: new BorderRadius.only(
              topLeft: const Radius.circular(40.0),
              topRight: const Radius.circular(40.0),
              bottomLeft: const Radius.circular(40.0),
              bottomRight: const Radius.circular(40.0),
            ),

          ),
          child: Padding(
            padding: EdgeInsets.all(2.0),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  DarkModeWidget(),
                  ShowFavWidget(),
                  Container(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(15, 10, 20, 0),
                        child: new TextFormField(
                          decoration: InputDecoration(
                              labelText: 'Select Source',
                              icon: new Icon(
                                Icons.assessment,
                                color: Colors.grey,
                              )
                          ),
                          validator: (input) => input.length < 8 ? 'You need at least 8 characters' : null, //add validator for the type of data source
                          onSaved: (input) => _password = input,
                        ),

                      )
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
>>>>>>> aab8f8c31b3339197d841daa41a1ff7594964a3b
            ),
          ),
        ),
      ),
    );
  }


  void _submit(){
    if(formKey.currentState.validate()){
      formKey.currentState.save();
      print(_email);
      print(_password);
    }
  }
}


