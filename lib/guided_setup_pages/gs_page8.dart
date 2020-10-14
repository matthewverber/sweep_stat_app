import 'package:flutter/material.dart';

class GSPage8 extends StatelessWidget {
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
          "Next, you need to select the potential (E) you wish to apply at the electrode surface. The experiment will start at the initial potential, ramp to the vertex potential, and return to the initial potential (hence, cyclic voltammetry). Because the goal is to observe the electrochemical response of your analyte, you should select an initial potential where no reaction is expected, and a final potential where you expect the reaction to be occurring.",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyText2),
      Padding(
          padding: EdgeInsets.symmetric(vertical: 15),
          child: Image(image: AssetImage('images/potential_graph.png'))),
    ]);
  }
}
