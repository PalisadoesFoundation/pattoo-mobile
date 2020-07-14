import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pattoomobile/views/pages/HomeScreen.dart';
import 'package:pattoomobile/widgets/LoginForm.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}
void main() {

  MaterialApp app = MaterialApp(
    home: Scaffold(
      body: showPrimaryButton(),
    ),
  );

  testWidgets('Login Widgets widget test', (WidgetTester tester) async {
    final mockObserver = MockNavigatorObserver();
    await tester.pumpWidget(
      MaterialApp(
        home: showPrimaryButton(),
        navigatorObservers: [mockObserver],
      )
    );

    // Create the widget by telling the tester to build it.
    //await tester.pumpWidget(app);
    expect(find.byType(RaisedButton), findsOneWidget);
    await tester.tap(find.byType(RaisedButton));
    await tester.pumpAndSettle();

    verify(mockObserver.didPush(any, any));
  });

}

Widget showPrimaryButton() {
  return new Padding(
    padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
    child: RaisedButton(
      elevation: 5.0,
      shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(30.0)),
      onPressed: () {
        //Navigator.pushReplacementNamed(context, '/HomeScreen');
      },
      child: const Text('Login',
          style: TextStyle(fontSize: 20, color: Colors.white)),
    ),
  );
}
//var result = FieldValidator.validateEmail('');
//expect(result, 'Enter Email!');