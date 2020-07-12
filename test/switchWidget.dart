import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pattoomobile/controllers/theme_manager.dart';
import 'package:pattoomobile/utils/app_themes.dart';
import 'package:provider/provider.dart';

void main() {

  // Define a test. The TestWidgets function also provides a WidgetTester
  // to work with. The WidgetTester allows building and interacting
  // with widgets in the test environment.
  testWidgets('MyWidget has a title and message', (WidgetTester tester) async {


    //Fav Switch Test
    await tester.pumpWidget(MyWidget());
    await tester.tap(find.byType(SwitchListTile));
    await tester.pump();
    //expect(find.byType(Text), findsWidgets);
    var val = _MyWidgetState._lights;
    expect(val, true);



  })
  ;
}
//var result = FieldValidator.validateEmail('');
//expect(result, 'Enter Email!');

//Show Favs switch - when favs added it will be modified to see of list changed
class MyWidget extends StatefulWidget {

  MyWidget({Key key}) : super(key: key);
  @override
  _MyWidgetState createState() => _MyWidgetState();
}
class _MyWidgetState extends State<MyWidget> {
  static bool _lights = false;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fav Switch Test',
      home: Scaffold(
        body: SwitchListTile(
          title: Text('Show Favourites'),
          value: _lights,
          onChanged: (bool value) {
            setState(() {
              _lights = value;
            });
          },

          secondary: const Icon(Icons.favorite_border),
        ),
      ),
    );
  }
}

class DarkModeWidget extends StatefulWidget {
  DarkModeWidget({Key key}) : super(key: key);
  @override
  _DarkModeWidgetState createState() => _DarkModeWidgetState();
}

class _DarkModeWidgetState extends State<DarkModeWidget> {


  @override
  Widget build(BuildContext context) {
    bool _lights = Provider.of<ThemeManager>(context, listen: false).getTheme() == AppTheme.Light ? false : true;
    builder: (context) => ThemeManager();
    AppTheme theme;
    return MaterialApp(
      title: 'Fav Switch Test',
      home: Scaffold(
        body: SwitchListTile(
          title: Text('Show Favourites'),
          value: _lights,
          onChanged: (bool value) {
            setState(() {
              _lights = value;
            });
          },

          secondary: const Icon(Icons.favorite_border),
        ),
      ),
    );
  }
}
