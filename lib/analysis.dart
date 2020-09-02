import 'dart:math';

import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:permission_handler/permission_handler.dart';
import 'package:sweep_stat_app/experiment_settings.dart';

class FileNamePopup extends StatefulWidget {
  // TODO: Might not be needed since we are getting a project name and can have a generic _config _experiment
  final Function onSave;

  FileNamePopup({Key key, this.onSave}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _FileNamePopupState();
  }
}

class _FileNamePopupState extends State<FileNamePopup> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final _textController = new TextEditingController();
  bool saving = false;
  bool saveStatus;

  @override
  Widget build(BuildContext context) {
    if (saving) {
      return AlertDialog(content: CircularProgressIndicator());
    } else if (saveStatus != null) {
      if (saveStatus) {
        return AlertDialog(
          content: Column(
            children: [
              Text("Save Complete!"),
              RaisedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Ok!"))
            ],
          ),
        );
      } else {
        return AlertDialog(
            content: Column(
              children: [
                Text("There was a problem saving!"),
                RaisedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Ok!"))
              ],
            ));
      }
    } else {
      return AlertDialog(
        content: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    labelText: "File Name",
                  ),
                  validator: (String newText) {
                    if (newText.isNotEmpty) {
                      return null;
                    } else {
                      return "Can't have an empty file name!";
                    }
                  },
                  onSaved: (String fileName) {
                    Future<bool> saved = widget.onSave(_textController.value.toString());
                    saved.then((bool didSave) {
                      setState(() {
                        saving = false;
                        saveStatus = didSave;
                      });
                    });
                    setState(() {
                      saving = true;
                    });
                  }),
              RaisedButton(
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();
                    }
                  },
                  child: Text("Save"))
            ],
          ),
        ),
      );
    }
  }
}

class ExperimentSettingsValues extends StatelessWidget {
  final ExperimentSettings settings;

  const ExperimentSettingsValues({Key key, this.settings}) : super(key: key);

  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [Text("Initial Voltage: ${settings.initialVoltage} V"), Text("High Voltage: ${settings.highVoltage} V")],
        ),
        Row(
          children: [
            Text("Low Voltage: ${settings.lowVoltage} V"),
            Text("Final Voltage: ${settings.finalVoltage} V"),
          ],
        ),
        Row(
          children: [
            Text("Initial Polarity: ${settings.isPositivePolarity ? "Positive" : "Negative"}"),
            Text("Scan Rate: ${settings.scanRate} V/s"),
          ],
        ),
        Row(
          children: [
            Text("Sweep Segments: ${settings.sweepSegments}"),
            Text("Sample Interval: ${settings.sampleInterval} V"),
          ],
        ),
        Row(
          children: [
            Text("Sensitivity: ${settings.isAutoSens}"),
            Text("Final Voltage Enabled: ${settings.isFinalE}"),
          ],
        ),
      ],
    );
  }
}

class AnalysisScreen extends StatefulWidget {
  /*
    It seems like everything is through shared preferences
  */
  final ExperimentSettings settings;

  const AnalysisScreen({Key key, this.settings}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _AnalysisScreenState();
  }
}

class _AnalysisScreenState extends State<AnalysisScreen> {
  List<DataPoints> experimentData = [];

  Future<bool> saveLocally() async {
    // TODO
    bool savedConfig = await widget.settings.writeToFile();
    // TODO: Write to file the data
    return true;
  }

  int i = 0; // TODO: temp remove, later
  Widget build(BuildContext context) {
    List<charts.Series<DataPoints, num>> experimentChart = [
      new charts.Series<DataPoints, double>(
        id: 'potential_vs_current',
        domainFn: (DataPoints data, _) => data.x,
        measureFn: (DataPoints data, _) => data.y,
        data: experimentData,
      )
    ];
    return Scaffold(
        body: Column(
          children: [
            Expanded(child: charts.LineChart(experimentChart, animate: true)),
            EnabledSettings(widget.settings),
            Row(
              children: [
                RaisedButton(
                    child: Text("Back"),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
                RaisedButton(
                    child: Text("Run Experiment"),
                    onPressed: () {
                      setState(() {
                        experimentData.add(new DataPoints(i + 1.0, sin(i + 1.0)));
                        i += 1;
                      });
                    })
              ],
            ),
            Row(
              children: [
                RaisedButton(
                    onPressed: () async {
                      // showDialog
                      showDialog(context: context, builder: (BuildContext context) => FileNamePopup(onSave: saveLocally));
                    },
                    child: Text("Save Locally")),
                RaisedButton(onPressed: () {}, child: Text("Export"))
              ],
            )
          ],
        ));
  }
}

class DataPoints {
  final double x;
  final double y;

  DataPoints(this.x, this.y);
}
