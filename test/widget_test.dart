import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';


void main() {
  testWidgets('Nav test', (WidgetTester tester) async{
    await tester.pumpWidget(ButtonTest());

    expect(find.byType(RaisedButton), findsNWidgets(1));
  });
}

class ButtonTest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
      child: RaisedButton(
        elevation: 5.0,
        shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(30.0)),
        onPressed: () {
          Navigator.pushReplacementNamed(context, '/HomeScreen');
        },
        child: const Text('Login',
            style: TextStyle(fontSize: 20, color: Colors.white)),
      ),
    );
  }
}
