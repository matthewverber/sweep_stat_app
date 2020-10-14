import 'package:flutter/material.dart';

class GSPage2 extends StatelessWidget {
  Widget build(BuildContext context){
    return ListView(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 15),
          child: Image(
            image: AssetImage('images/sweephelper.png'),
            height: 80,
            width: 80,
          )
        ),
        Text(
          "This assistant is best used for investigating the electrochemical response of outer-sphere electrochemical reactions, where the voltammograms will take one of two possible shapes:",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyText2
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical:15),
          child: Image(
            image: AssetImage('images/sample_graphs.png')
          )
        ),
        Text(
          "Here, the current (I) resulting from the reaction of a molecule with the electrode surface is plotted against the potential (E). It is clear from this plot that one must exceed a certain potential in order to drive the current-producing reaction. There are two main regions of each voltammogram, the kinetically limited region and the mass transfer limited region, both of which are manifested at different potentials.",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyText2
        )

      ]
    );
  }
}