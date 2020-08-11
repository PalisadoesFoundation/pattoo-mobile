import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pattoomobile/widgets/SettingsContainer.dart';

void main() {
  bool value = false;
  Widget buildTestableWidget(Widget widget) {
    return MediaQuery(data: MediaQueryData(), child: MaterialApp(home: widget));
  }

  testWidgets('Switch test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(buildTestableWidget(SettingsContainer()));

    // Verify that our counter starts at 0.
    expect(find.byType(Switch), findsOneWidget);
    await tester.tap(find.byType(Switch));
    await tester.pump();
    expect(value, isFalse);
    await tester.pump();
    await tester.press(find.byType(Switch));

    await tester.pump();
    expect(value, isTrue);
  });
}
