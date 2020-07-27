import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pattoomobile/controllers/agent_controller.dart';
import 'package:pattoomobile/controllers/theme_manager.dart';
import 'package:pattoomobile/models/agent.dart';
import 'package:pattoomobile/widgets/AgentOptions.dart';

import 'package:provider/provider.dart';

void main() {
  group("Agent Screen Widgets Test", () {
/*     testWidgets('Agent Tiles', (WidgetTester tester) async {
      await tester.pumpWidget(MultiProvider(
          providers: [
            ChangeNotifierProvider<ThemeManager>(create: (_) => ThemeManager()),
            ChangeNotifierProvider<AgentsManager>(
                create: (_) => AgentsManager())
          ],
          child: ClientProvider(
              uri: "SomeURI",
              child: Builder(builder: (BuildContext context) {
                var actual = find.byWidget(AgentsList().showOptions(context));
                expect(actual, DisplayMessage());
                return Container();
              }))));
    }); */

    testWidgets("Agent Cards", (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
          home: MultiProvider(
              providers: [
            ChangeNotifierProvider<ThemeManager>(create: (_) => ThemeManager()),
            ChangeNotifierProvider<AgentsManager>(
                create: (_) => AgentsManager())
          ],
              child: Builder(builder: (BuildContext context) {
                return agentButton(context, Agent("1", "Program"));
              }))));
      await tester.pumpAndSettle();
      var findByText = find.byType(Text);
      var findByButton = find.byType(RaisedButton);
      expect(findByText.evaluate().isEmpty, false);
      expect(findByButton.evaluate().isEmpty, false);
    });
  });
}
