import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pattoomobile/widgets/ShowFavSwitch.dart';

void main() {
  Widget buildTestableWidget(Widget widget) {
    return MediaQuery(data: MediaQueryData(), child: MaterialApp(home: widget));
  }

  testWidgets('Show Fav Switch', (WidgetTester tester)
  async{
    await tester.pumpWidget(buildTestableWidget(ShowFavWidget()));

    expect(find.byType(Switch), findsNothing);
  });
}