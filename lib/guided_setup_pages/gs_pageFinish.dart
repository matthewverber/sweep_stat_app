import 'package:flutter/material.dart';

class GSPageFinish extends StatelessWidget {
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
          "Excellent! We are now ready to make the measurement. If you have not done so already, please place the counter/reference electrode in the solution and connect the black clip. Then, place the working electrode in the solution and connect the red clip. It is important to place these electrodes in the solution before connecting the clips to reduce the likelihood of static discharge damaging the electrodes.",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyText2),
    ]);
  }
}
