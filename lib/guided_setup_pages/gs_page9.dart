import 'package:flutter/material.dart';

class GSPage9 extends StatefulWidget {
  final Function callbackInitPot, callbackVertPot;
  final double initialPot, vertexPot;
  const GSPage9(
      {Key key,
      this.initialPot,
      this.vertexPot,
      this.callbackInitPot,
      this.callbackVertPot})
      : super(key: key);
  @override
  GSPage9State createState() => GSPage9State();
}

class GSPage9State extends State<GSPage9> {
  double _initPot, _vertPot;

  void initState() {
    super.initState();
    _initPot = widget.initialPot;
    _vertPot = widget.vertexPot;
  }

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
          "When selecting a potential range, it is important to consider the solvent window, which indicates the potential at which the solvent itself begins to react with the electrode surface. At a pH of 7, the solvent window for a carbon electrode is around -1 to 1V vs Ag/AgCl. For typical outer-sphere oxidation experiments, a potential range of 0 to 0.6 V vs Ag/AgCl is recommended.",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyText2),
      Padding(
        padding: EdgeInsets.all(15),
        child: Column(children: [
          Text("Please enter the initial and vertex potential:",
              textAlign: TextAlign.left,
              style: Theme.of(context).textTheme.bodyText2),
          // Based on Flutter TextField change handling guide: https://flutter.dev/docs/cookbook/forms/text-field-changes
          TextField(
              autocorrect: false,
              obscureText: false,
              decoration: InputDecoration(labelText: 'Initial Potential'),
              onChanged: (String value) {
                double dblValue = double.parse(value);
                assert(dblValue is double);
                widget.callbackInitPot(dblValue);
                setState(() {
                  _initPot = dblValue;
                });
              }),
          TextField(
              autocorrect: false,
              obscureText: false,
              decoration: InputDecoration(labelText: 'Vertex Potential'),
              onChanged: (String value) {
                double dblValue = double.parse(value);
                assert(dblValue is double);
                widget.callbackVertPot(dblValue);
                setState(() {
                  _vertPot = dblValue;
                });
              })
        ]),
      ),
    ]);
  }
}
