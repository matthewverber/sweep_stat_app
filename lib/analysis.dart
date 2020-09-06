import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:sweep_stat_app/experiment.dart';
import 'package:fl_chart/fl_chart.dart';

class FileNamePopup extends StatefulWidget {
  // TODO: Might not be needed since we are getting a project name and can have a generic _config _experimentube

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
  final Experiment experiment;

  const AnalysisScreen({Key key, this.experiment}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _AnalysisScreenState();
  }
}

class _AnalysisScreenState extends State<AnalysisScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  // TODO: Move spots to Experiment class !
  List<FlSpot> spots = [new FlSpot(0, 0)];
  List<FlSpot> spotstwo = [new FlSpot(0, 0)];
  LineChartBarData dataone;
  LineChartBarData datatwo;

  Future<bool> saveLocally() async {
    return await widget.experiment.saveExperiment();
  }

  Future<bool> shareFiles() async {
    bool didSave = await saveLocally();
    if (didSave) {
      Directory experimentDir = await widget.experiment.getOrCreateCurrentDirectory();
      Share.shareFiles([
        '${experimentDir.path}/${widget.experiment.settings.projectName}_config.csv',
        '${experimentDir.path}/${widget.experiment.settings.projectName}_data.csv'
      ]);
      return true;
    } else {
      return false;
    }
  }

  void initState() {
    dataone = LineChartBarData(spots: spots, isCurved: true);
    datatwo = LineChartBarData(spots: spotstwo, isCurved: true);
    super.initState();
  }

  bool lock = false;

  int i = 0; // TODO: temp remove, later
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 16.0, left: 0),
                  child: LineChart(LineChartData(
                      lineBarsData: [dataone, datatwo],
                      axisTitleData: FlAxisTitleData(
                          show: true,
                          leftTitle: AxisTitle(titleText: "Current i (AM)"),
                          bottomTitle: AxisTitle(titleText: "Potential E (V)"),
                          topTitle: AxisTitle(titleText: "Currnt Vs Potential"),
                          rightTitle: AxisTitle(titleText: "")))),
                ),
              ),
              ExperimentSettingsValues(settings: widget.experiment.settings),
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
                        Timer.periodic(new Duration(milliseconds: 50), (timer) {
                          setState(() {
                            spots.add(new FlSpot(i + 0.0, 3 * sin(i + 0.0)));
                            spotstwo.add(new FlSpot(i + 1.0, cos(i + 1.0)));
                            i += 1;
                          });
                        });
                      })
                ],
              ),
              Row(
                children: [
                  RaisedButton(
                      onPressed: () async {
                        // showDialod
                        if (await saveLocally()) {
                          _scaffoldKey.currentState.showSnackBar(SnackBar(
                            content: Text("Saved successfully!"),
                            duration: Duration(seconds: 1),
                          ));
                        } else {
                          _scaffoldKey.currentState.showSnackBar(SnackBar(
                            content: Text("Failed to save, please try again!"),
                            duration: Duration(seconds: 1),
                          ));
                        }
                      },
                      child: Text("Save Locally")),
                  RaisedButton(
                      onPressed: () async {
                        // showDialod
                        if (!(await shareFiles())) {
                          _scaffoldKey.currentState.showSnackBar(SnackBar(
                            content: Text("Failed to save, please try again!"),
                            duration: Duration(seconds: 3),
                          ));
                        }
                      },
                      child: Text("Send Data"))
                ],
              )
            ],
          ),
        ));
  }
}
