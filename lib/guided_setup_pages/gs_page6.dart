import 'package:flutter/material.dart';

class GSPage6 extends StatelessWidget {
  Widget build(BuildContext context) {
    return ListView(children: [
      Padding(
          padding: EdgeInsets.symmetric(vertical: 15),
          child: Image(
            image: AssetImage('images/sweephelper.png'),
            height: 80,
            width: 80,
          )),
      Text(
          "Let’s talk about the other electrode we will use to make this measurement:",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyText2),
      Padding(
        padding: EdgeInsets.only(top: 20, bottom: 20),
        child: Text(
            "Because a voltage measurement is always a differential measurement (meaning that voltage can only be measured relative to another voltage), most experiments compare the potential against a reference electrode, which has a defined equilibrium. Most potentiostats add this reference electrode component in a three-electrode configuration to avoid passing current through the reference, thus disturbing its equilibrium.",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyText2),
      ),
      Text(
          "A counter electrode is used to complete the electric circuit through the solution.",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyText2),
    ]);
  }
}
