import 'package:flutter/material.dart';

class GSPage4 extends StatelessWidget {
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
          "Current is defined as the number of charges (C) that flow per second (s).",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyText2),
      Padding(
        padding: EdgeInsets.only(top: 20, bottom: 20),
        child: Text(
          "I=C/s",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 30),
        ),
      ),
      Text(
          "The magnitude of the current response you will observe is proportional to the size of the electrode. We may rationalize this by thinking of electrons flowing through a pipe, where the bigger the pipe, the larger the volume of electrons that can flow through it in a certain period of time.",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyText2)
    ]);
  }
}
