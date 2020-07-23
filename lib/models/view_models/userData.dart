import 'package:flutter/cupertino.dart';
import 'package:pattoomobile/controllers/userState.dart';
import 'package:provider/provider.dart';

class NameDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userState = Provider.of<UserState>(context);

    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        userState.getUserName,
        style: TextStyle(
          fontSize: 24.0,
        ),
      ),
    );
  }
}
