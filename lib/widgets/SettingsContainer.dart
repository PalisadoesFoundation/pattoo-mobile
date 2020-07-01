import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pattoomobile/util/validator.dart';
import 'DarkModeSwitch.dart';
import 'ShowFavSwitch.dart';

class SettingsContainer extends StatefulWidget {

  @override
  _SettingsContainerState createState() => _SettingsContainerState();
}

class _SettingsContainerState extends State<SettingsContainer> {
  final formKey = GlobalKey<FormState>();
  String _source;
  String dropdownValue = 'HTTP';
  String dropdownValue2 = '/pattoo/api/v1/';
  bool isSwitched = false;
  bool status = false;

  @override
  Widget build(BuildContext context) {
        final size = MediaQuery.of(context).size;
    return MaterialApp(
      home: Scaffold(
        body: Container(
          child: Column(
            children: <Widget>[
              FavSwitch(),
              DarkSwitch(),
            ],
          )
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget FavSwitch()
  {
    bool _isSwitched = true;
    return MaterialApp(
      home: Scaffold
        (
        body: Container(
          child: Row(
            children: <Widget>[
              Icon(
                Icons.favorite_border,
                color:Colors.grey,
                size: 25.0,
                semanticLabel: 'Text to announce in accessibility modes',
              ),
              Text(
                'Show Favourites',
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Switch(
                onChanged: (val) => setState(() => _isSwitched = val),
                value: _isSwitched,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget DarkSwitch()
  {
    bool _isSwitched = true;
    return MaterialApp(
      home: Scaffold
        (
        body: Container(
          child: Row(
            children: <Widget>[
              Icon(
                Icons.lightbulb_outline,
                color:Colors.grey,
                size: 25.0,
                semanticLabel: 'Text to announce in accessibility modes',
              ),
              Text(
                'Dark Mode',
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Switch(
                onChanged: (val) => setState(() => _isSwitched = val),
                value: _isSwitched,
              ),
            ],
          ),
        ),
      ),
    );
  }



  Widget _buildVerticalLayout()
  {
    return new Container(
         child: Center(
           child: Padding(
             padding: EdgeInsets.all(8.0),
             child: SingleChildScrollView(
               key: formKey,
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.center,
                 children: <Widget>[
                   DarkModeWidget(),
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

  void _submit(){
    if(formKey.currentState.validate()){
      formKey.currentState.save();
      print(_source);
    }
  }
}
