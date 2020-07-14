import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pattoomobile/controllers/theme_manager.dart';
import 'package:pattoomobile/utils/app_themes.dart';
import 'package:pattoomobile/widgets/ShowFavSwitch.dart';
import 'package:provider/provider.dart';

void main() {

  MaterialApp app = MaterialApp(
    home: Scaffold(
        body: ShowFavWidget()
    ),
  );

  testWidgets('swttings container test', (WidgetTester tester) async {
    // Create the widget by telling the tester to build it.
    await tester.pumpWidget(app);
    await tester.tap(find.byType(SwitchListTile));
    await tester.pump();

    final sometext = find.text('Show Favourites');
    expect(sometext, findsOneWidget);
  });

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
