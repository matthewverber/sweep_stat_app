import 'package:flutter/material.dart';

class GSPage1 extends StatelessWidget {
  Widget build(BuildContext context){
    return ListView(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Image(
              image: AssetImage('images/sweephelper.png'),
              height: 160,
              width: 160,
            )
          ),
          Text(
            "Welcome to the SweepStat Experimental Assistant. The goal of this assistant is to provide an educational experience to deepen your understanding of the parameters involved in making electrochemical measurements. If you are an advanced user, you may return to the home screen and select “Run Advanced Experiment” to directly enter parameters without educational commentary. Otherwise, press next to get started.",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyText1
          )
        ]
    );
  }
}