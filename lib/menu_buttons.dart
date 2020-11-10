import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

abstract class MenuButton extends StatelessWidget {
  final Key key;
  final String text;
  final Route route;

  MenuButton(this.text, this.key, this.route);
}

class PrimaryMenuButton extends MenuButton {
  PrimaryMenuButton(String text, Key key, Route route)
      : super(text, key, route);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(10),
        child: SizedBox(
            width: 200,
            height: 50,
            child: FlatButton(
              color: Colors.blue,
              textColor: Colors.white,
              disabledColor: Colors.grey,
              disabledTextColor: Colors.black,
              padding: EdgeInsets.all(5.0),
              splashColor: Colors.blueAccent,
              onPressed: () {
                Navigator.push(context, route);
              },
              child: Text(
                text,
                style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 12.0,
                    fontWeight: FontWeight.w500),
              ),
            )));
  }
}

class SecondaryMenuButton extends MenuButton {
  SecondaryMenuButton({String text, Key key, Route route})
      : super(text, key, route);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
