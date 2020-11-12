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
    return FlatButton(
      color: Colors.blue,
      textColor: Colors.white,
      disabledColor: Colors.grey,
      disabledTextColor: Colors.black,
      padding: EdgeInsets.all(5.0),
      splashColor: Colors.blueAccent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      onPressed: () {
        Navigator.push(context, route);
      },
      child: Text(
        text,
        style: TextStyle(
            fontFamily: 'Roboto', fontSize: 12.0, fontWeight: FontWeight.w500),
      ),
    );
  }
}

class SecondaryMenuButton extends MenuButton {
  SecondaryMenuButton(String text, Key key, Route route)
      : super(text, key, route);

  @override
  Widget build(BuildContext context) {
    return OutlineButton(
      color: Colors.grey,
      textColor: Colors.blue,
      disabledBorderColor: Colors.grey,
      disabledTextColor: Colors.grey,
      padding: EdgeInsets.all(8.0),
      splashColor: Colors.blueAccent,
      onPressed: () {
        Navigator.push(context, route);
      },
      child: Text(
        text,
        style: TextStyle(fontSize: 15.0),
      ),
    );
  }
}
