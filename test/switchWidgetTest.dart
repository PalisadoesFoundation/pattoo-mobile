import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pattoomobile/widgets/Settings.dart';
import 'package:pattoomobile/widgets/ShowFavSwitch.dart';
import 'package:pattoomobile/widgets/DarkModeSwitch.dart';


void main() {
  final Key switchKey = UniqueKey();
  bool value = false;
  Widget buildTestableWidget(Widget widget)
  {
    return MediaQuery(data: MediaQueryData(), child: MaterialApp(home: widget));
  }

  testWidgets('Switch test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(buildTestableWidget(ShowFavWidget()));

    // Verify that our counter starts at 0.
    expect(find.byType(SwitchListTile), findsOneWidget);


  });
}