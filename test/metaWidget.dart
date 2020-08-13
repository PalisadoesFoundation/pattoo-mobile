import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pattoomobile/widgets/MetaDataTile.dart';


void main() {

  MaterialApp app = MaterialApp(
    home: Scaffold(
      body: TileSample(),
    ),
  );

  testWidgets('Meta Data Tile test', (WidgetTester tester) async {
    // Create the widget by telling the tester to build it.
    await tester.pumpWidget(app);
    expect(find.byType(ListTile), findsOneWidget);
    expect(find.byType(Text), findsNWidgets(2));
    expect(find.byType(Wrap), findsOneWidget);
  });

}

Widget TileSample()
{
    return new ListTile(
      leading: Icon(Icons.timeline),
      title: Text('Title', style: TextStyle(fontWeight: FontWeight.bold)),
      trailing: SizedBox(
        child: Wrap(
            textDirection: TextDirection.ltr,
            direction: Axis.horizontal,
            children: <Widget>[
              Text('data', style: TextStyle(fontWeight: FontWeight.bold))
            ]),
      ));
}
//var result = FieldValidator.validateEmail('');
//expect(result, 'Enter Email!');