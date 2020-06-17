import 'package:flutter/material.dart';
import 'package:pattoomobile/main.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pattoomobile/views/pages/SettingsScreen.dart';
import 'package:pattoomobile/widgets/SettingsContainer.dart';

void main()
{
  testWidgets('Submit widget', (WidgetTester tester)
  async{
    await tester.pumpWidget(SettingsContainer());

    expect(find.byType(RaisedButton), findsNWidgets(2));

  });
}