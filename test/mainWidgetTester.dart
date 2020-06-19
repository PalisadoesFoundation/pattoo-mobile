import 'package:flutter/material.dart';
import 'package:pattoomobile/main.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pattoomobile/views/pages/LoginScreen.dart';
import 'package:pattoomobile/views/pages/SettingsScreen.dart';
import 'package:pattoomobile/widgets/SettingsContainer.dart';

void main()
{
  Widget buildTestableWidget(Widget widget)
  {
    return MediaQuery(data: MediaQueryData(), child: MaterialApp(home: widget));
  }

  testWidgets('Submit widget', (WidgetTester tester)
  async{
    await tester.pumpWidget(buildTestableWidget(SettingsContainer()));

    expect(find.byType(RaisedButton), findsNWidgets(1));

    await tester.tap(find.byType(RaisedButton));
    await tester.pump();
    expect(find.text('sample'), findsOneWidget);


  });
}