import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pattoomobile/controllers/theme_manager.dart';
import 'package:provider/provider.dart';
import 'package:pattoomobile/util/AspectRation.dart';
import 'package:pattoomobile/util/validator.dart';
import 'DarkModeSwitch.dart';
import 'ShowFavSwitch.dart';
import 'package:pattoomobile/models/view_models/listItem.dart';

class SettingsContainer extends StatefulWidget {
  @override
  _SettingsContainerState createState() => _SettingsContainerState();
}

class _SettingsContainerState extends State<SettingsContainer> {
  final formKey = GlobalKey<FormState>();
  String _source;
  String dropdownValue = 'HTTP';
  String dropdownValue2 = '/pattoo/api/v1/';
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

  Widget _buildVerticalLayout() {
    return new Scaffold(
      body: Container(
        height: SizeConfig.blockSizeVertical * 51,
        width: SizeConfig.blockSizeHorizontal * 150,
        color: Colors.transparent,
        child: Card(
          elevation: 5,
          margin: EdgeInsets.fromLTRB(20, 30, 20, 40),
          shape: RoundedRectangleBorder(
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
                          )),
                      validator: (input) => Validator(input)
                              child: new TextField(
                                decoration:  const InputDecoration(helperText: "Select Source",
                                 ),
                              ),
                            ),
                           SizedBox(width: 20,),
                           new DropdownButton<String>(

                             value: dropdownValue,
                             icon: Icon(Icons.arrow_downward),
                             iconSize: 24,
                             elevation: 16,
                             style: TextStyle(
                                 color: Colors.deepPurple
                             ),
                             underline: Container(
                               height: 2,
                               color: Colors.deepPurpleAccent,
                             ),
                             onChanged: (String newValue) {
                               setState(() {
                                 dropdownValue = newValue;
                               });
                             },
                             items: <String>['HTTP', 'HTTPS',]
                                 .map<DropdownMenuItem<String>>((String value) {
                               return DropdownMenuItem<String>(
                                 value: value,
                                 child: Text(value),
                               );
                             })
                                 .toList(),
                           ),
                           SizedBox(width: 20,),
                           new DropdownButton<String>(

                             value: dropdownValue2,
                             icon: Icon(Icons.arrow_downward),
                             iconSize: 24,
                             elevation: 16,
                             style: TextStyle(
                                 color: Colors.deepPurple
                             ),
                             underline: Container(
                               height: 2,
                               color: Colors.deepPurpleAccent,
                             ),
                             onChanged: (String newValue) {
                               setState(() {
                                 dropdownValue2 = newValue;
                               });
                             },
                             items: <String>['/pattoo/api/v1/']
                                 .map<DropdownMenuItem<String>>((String value) {
                               return DropdownMenuItem<String>(
                                 value: value,
                                 child: Text(value),
                               );
                             })
                                 .toList(),
                           ),
                         ],
                       ),
                    ),
                  )),
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
    );
  }

  Widget _buildHorizontalLayout() {
    return new Scaffold(
      body: Container(
        height: SizeConfig.blockSizeVertical * 100,
        width: SizeConfig.blockSizeHorizontal * 150,
        color: Colors.transparent,
        child: Card(
          elevation: 5,
          margin: EdgeInsets.fromLTRB(40, 10, 40, 0),
          shape: RoundedRectangleBorder(
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
                              labelText: 'Select Source 2',
                              icon: new Icon(
                                Icons.assessment,
                                color: Colors.grey,
                              )
                          ),
                          validator: FieldValidator.validateSourceInput,
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
