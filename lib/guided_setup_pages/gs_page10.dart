import 'package:flutter/material.dart';

class GSPage10 extends StatefulWidget {
  final Function callback;
  final double scanRate;
  const GSPage10({Key key, this.scanRate, this.callback}) : super(key: key);
  @override
  GSPage10State createState() => GSPage10State();
}

class GSPage10State extends State<GSPage10> {
  double _scanRate;

  void initState() {
    super.initState();
    _scanRate = widget.scanRate;
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
          "Now that we know the potentials to scan over, we must consider the scan rate. Altering the scan rate over several experiments can be a useful tool for diagnosing the reactivity of analyte at macroelectrodes. Scan rates accessible to the SweepStat range from 0.005 to 0.5 V/s. For beginners, a good place to start is 0.05 V/s.",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyText2),
      Padding(
        padding: EdgeInsets.all(15),
        child: Column(children: [
          Text("Please enter your desired scan rate:",
              textAlign: TextAlign.left,
              style: Theme.of(context).textTheme.bodyText2),
          // Based on Flutter TextField change handling guide: https://flutter.dev/docs/cookbook/forms/text-field-changes
          TextField(
              autocorrect: false,
              obscureText: false,
              decoration: InputDecoration(labelText: 'Scan Rate'),
              onChanged: (String value) {
                double dblValue = double.parse(value);
                assert(dblValue is double);
                widget.callback(dblValue);
                setState(() {
                  _scanRate = dblValue;
                });
              }),
        ]),
      ),
    ]);
  }
}
