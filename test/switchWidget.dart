import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {



  // Define a test. The TestWidgets function also provides a WidgetTester
  // to work with. The WidgetTester allows building and interacting
  // with widgets in the test environment.
  testWidgets('MyWidget has a title and message', (WidgetTester tester) async {
    // Create the widget by telling the tester to build it.
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

//DarkModeWidget
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
      title: 'Switch Test',
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
