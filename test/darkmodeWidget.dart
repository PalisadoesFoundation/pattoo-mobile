import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pattoomobile/controllers/theme_manager.dart';
import 'package:pattoomobile/utils/app_themes.dart';
import 'package:pattoomobile/widgets/DarkModeSwitch.dart';
import 'package:pattoomobile/widgets/ShowFavSwitch.dart';
import 'package:provider/provider.dart';

void main() {

  MaterialApp app = MaterialApp(
    home: Scaffold(
        body: DarkModeWidget(),
    ),
  );

  testWidgets('Dark mode container test', (WidgetTester tester) async {
    // Create the widget by telling the tester to build it.
    await tester.pumpWidget(app);
    await tester.tap(find.byType(SwitchListTile));
    await tester.pump();

    final sometext = find.text('Dark Mode');
    expect(sometext, findsOneWidget);
  });

}
//var result = FieldValidator.validateEmail('');
//expect(result, 'Enter Email!');