
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pattoomobile/util/validator.dart';
import 'package:pattoomobile/widgets/DarkModeSwitch.dart';
import 'package:pattoomobile/widgets/ShowFavSwitch.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isSwitched = false;
  final formKey = GlobalKey<FormState>();
  String _source;
  String dropdownValue = 'HTTP';
  String dropdownValue2 = '/pattoo/api/v1/';
  bool status = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body:
      Center(
        child: ListView(
          children: <Widget>[
            SizedBox(height: 30),
            DarkModeWidget(),
            SizedBox(height: 20),
            ShowFavWidget(),
            Container(
              child: Row(
                children: <Widget>[
                  SizedBox(width: 15,),
                  new Flexible(child:
                  Icon(
                    Icons.assessment,
                    color: Colors.grey,
                    size: 25.0,
                  ),),
                  SizedBox(width: 10,),
                  new Flexible(
                    // flex:1,
                    child: new TextFormField(
                      maxLines: 1,
                      obscureText: false,
                      autofocus: false,
                      decoration:  const InputDecoration(helperText: "Select Source",
                      ),
                      validator: FieldValidator.validateSourceInput,
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
            

  ],
      ),
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
}

