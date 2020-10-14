import 'package:flutter/material.dart';

class GSPage5 extends StatelessWidget {
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
          "We must adjust the “sensitivity” setting of the SweepStat to ensure the device can see and measure our signal. If you chose the macroelectrode, please ensure that all the jumpers on the SweepStat board are connected to their respective pins (JP1-in, JP2-in, JP3-in). If you are using a microelectrode, please remove the jumpers (JP1-out, JP2-out, JP3-out).",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyText2),
      Padding(
          padding: EdgeInsets.symmetric(vertical: 15),
          child: Image(image: AssetImage('images/sweepstat.png'))),
    ]);
  }
}
