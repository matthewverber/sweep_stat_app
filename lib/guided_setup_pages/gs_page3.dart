import 'package:flutter/material.dart';
import 'package:sweep_stat_app/experiment_settings.dart';

class GSPage3 extends StatefulWidget {
  final Function callback;
  final GainSettings selected;
  const GSPage3({Key key, this.callback, this.selected}) : super(key: key);
  @override
  GSPage3State createState() => GSPage3State();
}

class GSPage3State extends State<GSPage3> {
  GainSettings _gainValue;

  void initState() {
    super.initState();
    _gainValue = widget.selected;
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
          "The shape of your voltammogram will take is directly related to the concentration profiles of analyte about the working electrode surface. At typical scan rates, a macroelectrode (r > 25 µm) will produce a “duck shaped” voltammogram, while a micro- or ultramicroelectrode (r < 25 µm) will produce a sigmoidal voltammogram.",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyText2),
      Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Text(
              "What type of electrode are you using for this experiment?")),
      // Most of this formatting derived from https://api.flutter.dev/flutter/material/Radio-class.html
      Column(
        children: [
          ListTile(
              title: Text("Macroelectrode (r > 25 µm)"),
              leading: Radio(
                  value: GainSettings.nA10,
                  groupValue: _gainValue,
                  onChanged: (GainSettings value) {
                    widget.callback(value);
                    setState(() {
                      _gainValue = value;
                    });
                  })),
          ListTile(
              title: Text("Microelectrode (r < 25 µm)"),
              leading: Radio(
                  value: GainSettings.uA1,
                  groupValue: _gainValue,
                  onChanged: (GainSettings value) {
                    widget.callback(value);
                    setState(() {
                      _gainValue = value;
                    });
                  }))
        ],
      ),
      Text(
          "Note: it is important to connect this electrode to the red clip just before beginning the experiment, you will be prompted to make the connection at a later time.",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyText2)
    ]);
  }
}
