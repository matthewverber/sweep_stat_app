import 'package:flutter/material.dart';

abstract class MenuButton extends StatelessWidget {
  final Key key;
  final String text;
  final Widget widget;

  MenuButton(this.text, this.key, this.widget);
}

class PrimaryMenuButton extends MenuButton {
  PrimaryMenuButton(String text, Key key, Widget widget)
      : super(text, key, widget);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
        child: FlatButton(
          color: Colors.blue,
          textColor: Colors.white,
          disabledColor: Colors.grey,
          disabledTextColor: Colors.black,
          padding: EdgeInsets.fromLTRB(5.0, 20.0, 5.0, 20.0),
          splashColor: Colors.blueAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => widget));
          },
          child: Text(
            text,
            style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 16.0,
                fontWeight: FontWeight.w500),
          ),
        ));
  }
}

class SecondaryMenuButton extends MenuButton {
  SecondaryMenuButton(String text, Key key, Widget widget)
      : super(text, key, widget);

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
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => widget));
      },
      child: Text(
        text,
        style: TextStyle(
            fontFamily: 'Roboto', fontSize: 16.0, fontWeight: FontWeight.w500),
      ),
    );
  }
}
