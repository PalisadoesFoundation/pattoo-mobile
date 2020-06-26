import 'package:flutter/material.dart';

class Menu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: ClipOval(
          child: Material(
            color: Colors.white, // button color
            child: InkWell(
              splashColor: Colors.blueAccent, // inkwell color
              child: SizedBox(width: 56, height: 56, child: Icon(Icons.menu,
                color: Colors.blue,)),
              onTap: () {Navigator.pushNamed(context, '/Settings');},
            ),
          ),
        ),
    );
  }
}
