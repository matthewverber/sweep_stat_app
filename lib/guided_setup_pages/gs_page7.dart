import 'package:flutter/material.dart';
import 'package:sweep_stat_app/experiment_settings.dart';

class GSPage7 extends StatefulWidget {
  final Function callback;
  final Electrode selected;
  const GSPage7({Key key, this.callback, this.selected}) : super(key: key);
  @override
  GSPage7State createState() => GSPage7State();
}

class GSPage7State extends State<GSPage7> {
  Electrode _refElectrode;

  void initState() {
    super.initState();
    _refElectrode = widget.selected;
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
          "Because the SweepStat is a two-electrode configuration, the black lead represents a combined reference/counter electrode. If small currents are being passed, as is in the case of the microelectrode systems, a typical fritted reference such as a silver/silver chloride (Ag/AgCl) electrode may be installed on the black clip. If a macroelectrode is being used, which we expect to pass higher currents, please install an appropriate pseudo-reference/counter electrode (i.e. graphite rod, platinum wire) on the black clip.",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyText2),
      Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Text("Please select the reference electrode you are using:")),
      // Most of this formatting derived from https://api.flutter.dev/flutter/material/Radio-class.html
      Column(
        children: [
          ListTile(
              title: Text("Pseudo-Reference Electrode",
                  style: Theme.of(context).textTheme.bodyText2),
              leading: Radio(
                  value: Electrode.pseudoref,
                  groupValue: _refElectrode,
                  onChanged: (Electrode value) {
                    widget.callback(value);
                    setState(() {
                      _refElectrode = value;
                    });
                  })),
          ListTile(
              title: Text("Silver / Silver Chloride Electrode",
                  style: Theme.of(context).textTheme.bodyText2),
              leading: Radio(
                  value: Electrode.silver,
                  groupValue: _refElectrode,
                  onChanged: (Electrode value) {
                    widget.callback(value);
                    setState(() {
                      _refElectrode = value;
                    });
                  })),
          ListTile(
              title: Text("Saturated Calomel Electrode",
                  style: Theme.of(context).textTheme.bodyText2),
              leading: Radio(
                  value: Electrode.calomel,
                  groupValue: _refElectrode,
                  onChanged: (Electrode value) {
                    widget.callback(value);
                    setState(() {
                      _refElectrode = value;
                    });
                  })),
          ListTile(
              title: Text("Standard Hydrogen Electrode",
                  style: Theme.of(context).textTheme.bodyText2),
              leading: Radio(
                  value: Electrode.hydrogen,
                  groupValue: _refElectrode,
                  onChanged: (Electrode value) {
                    widget.callback(value);
                    setState(() {
                      _refElectrode = value;
                    });
                  })),
        ],
      ),
    ]);
  }
}
