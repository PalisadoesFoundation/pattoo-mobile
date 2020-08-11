import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pattoomobile/widgets/userData.dart';


void main()
{

  MaterialApp app = MaterialApp(
    home: Scaffold(
      body:ListScreen(),
    ),
  );


  testWidgets('Display user favs', (WidgetTester tester) async{
    await tester.pumpWidget(app);
    var appBar = find.byType(Card);
    expect(appBar, findsOneWidget);
  });
}