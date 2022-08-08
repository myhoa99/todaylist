import 'package:flutter/material.dart';

class RightNavigationBar extends StatefulWidget {
  @override
  _RightNavigationBarState createState() => new _RightNavigationBarState();
}

class _RightNavigationBarState extends State<RightNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: FractionalOffset.centerRight,
      child: Container(
        child: Column(
          children: [
            const Icon(Icons.navigate_next),
            const Icon(Icons.close),
            const Text("More items..")
          ],
        ),
        color: Colors.blueGrey,
        height: 700.0,
        width: 200.0,
      ),
    );
  }
}
