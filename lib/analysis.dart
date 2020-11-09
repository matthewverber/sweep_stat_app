import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:sweep_stat_app/experiment.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_blue/flutter_blue.dart';

import 'bluetooth_management.dart';
import 'experiment_settings.dart';
import 'bluetooth_connection.dart';

class FileNamePopup extends StatefulWidget {
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
            mainAxisSize: MainAxisSize.min,
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
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Filename already exists!"),
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
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                  controller: _textController,
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
                    Future<bool> saved = widget.onSave(_textController.text.toString());
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
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Expanded(
                    flex: 5,
                    child: RaisedButton(
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            _formKey.currentState.save();
                          }
                        },
                        child: Text("Save"))),
                Spacer(flex: 1),
                Expanded(
                    flex: 5,
                    child: RaisedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("Cancel")))
              ]),
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
    Widget settingsText(String text) {
      return Text(
        text,
        style: TextStyle(fontSize: 15),
      );
    }

    Widget settingsRow(String settingName, dynamic settingValue, String unitSymbol) {
      return Row(
          children: [Expanded(child: settingsText('$settingName')), settingsText('$settingValue $unitSymbol')],
          mainAxisAlignment: MainAxisAlignment.spaceBetween);
    }

    List<Widget> settingsValues;
    if (settings is VoltammetrySettings) {
      settingsValues = [
        Row(children: [Expanded(child: settingsText('Cyclic Voltammetry'))]),
        settingsRow("Initial Voltage", settings.initialVoltage, "V"),
        settingsRow("Vertex Voltage", (settings as VoltammetrySettings).vertexVoltage, "V"), // settings.highVoltage, "V"),
        settingsRow("Final Voltage", (settings as VoltammetrySettings).finalVoltage, "V"), // settings.highVoltage, "V"),
        settingsRow("Scan Rate", (settings as VoltammetrySettings).scanRate, "V/s"), // settings.scanRate, "V/s"),
        settingsRow("Sweep Segments", (settings as VoltammetrySettings).sweepSegments, ""), //  settings.sweepSegments, ""),
        settingsRow("Sample Interval", settings.sampleInterval, "V"),
        settingsRow("Gain Setting", settings.gainSetting.describeEnum(), ""),
        settingsRow("Electrode", settings.electrode.toString().split('.').last, "")
      ];
    } else {
      settingsValues = [
        Row(children: [Expanded(child: settingsText('Amperometry'))]),
        settingsRow("Initial Voltage", settings.initialVoltage, "V"),
        settingsRow("Sample Interval", settings.sampleInterval, "V"),
        settingsRow("Runtime", (settings as AmperometrySettings).runtime, "S"),
        settingsRow("Gain Setting", settings.gainSetting.describeEnum(), ""),
        settingsRow("Electrode", settings.electrode.toString().split('.').last, "")
      ];
    }
    return Padding(
        padding: EdgeInsets.only(left: 30, right: 30),
        child: Column(
          children: [
            Text(
              "Settings",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 25),
            ),
            Divider(),
            ...settingsValues
          ],
        ));
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
  SweepStatBTConnection sweepStatBTConnection;
  Utf8Decoder dec = Utf8Decoder();
  String incString = "";

  LineChartBarData dataL;
  LineChartBarData dataR;
  double i, j; // TODO temp: remove later
  Timer callbackTimer;

  Future<bool> saveLocally(String fileName) async {
    return await widget.experiment.saveExperiment(fileName);
  }

  Future<bool> shareFiles() async {
    String fileName;
    await showDialog(
        context: context,
        builder: (BuildContext context) => FileNamePopup(onSave: (String name) {
          fileName = name;
          return Future<bool>.value(true);
        }));
    Directory appDocDir = await getApplicationDocumentsDirectory();
    Directory experimentDir = Directory(appDocDir.path + '/temp/');
    if (!await experimentDir.exists()) {
      experimentDir = await experimentDir.create();
    }
    File experimentFile = new File(experimentDir.path + fileName + '.txt');
    await experimentFile.writeAsString(widget.experiment.toString());
    await Share.shareFiles(['${experimentDir.path}$fileName.txt']);
    await experimentFile.delete();
    return true;
  }

/*
  void onBTDisconnect(){
    sweepStatBTConnection = null;
    Scaffold.of(context).showSnackBar(SnackBar(content: Text('Bluetooth Disconnected')));

  }*/
  void plotBTPoint(List<int> intMessage) {
    if (dec.convert(intMessage) == "\$") return;
    String message = dec.convert(intMessage);
    if (!message.endsWith('}')) {
      incString = message;
      return;
    }
    message = incString + message;
    incString = "";
    List<String> parts = message.split(',');
    double volt = double.parse(parts[1].substring(2));
    double charge = double.parse(parts[2].substring(2, parts[2].length - 1));
    if (mounted) {
      setState(() {
        widget.experiment.dataL.add(new FlSpot(volt, charge));
      });
    }
  }

  Future<void> bluetooth(BuildContext context) async {
    if (sweepStatBTConnection == null) {
      BluetoothDevice device = await showDialog(
          context: context,
          builder: (BuildContext context) {
            return BlueToothSelection();
          }) as BluetoothDevice;
      await device.connect();
      sweepStatBTConnection = await SweepStatBTConnection.createSweepBTConnection(device, null);
      setState(() {
        sweepStatBTConnection = sweepStatBTConnection;
      });
      await sweepStatBTConnection.addNotifyListener(plotBTPoint);
      print('ready to send');
    }
  }

  void initState() {
    dataL = LineChartBarData(
      spots: widget.experiment.dataL,
      isCurved: true,
    );
    dataR = LineChartBarData(spots: widget.experiment.dataR, isCurved: true, curveSmoothness: .1, colors: [Colors.blueAccent]);
    i = 0.0; // TODO: temp remove, later
    j = 0.0;
    super.initState();
  }

  void dispose() {
    super.dispose();
    if (callbackTimer != null) {
      callbackTimer.cancel();
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            actions: [
              IconButton(
                  icon: Icon(Icons.settings),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Dialog(
                            child: Column(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.center, children: [
                              ExperimentSettingsValues(settings: widget.experiment.settings),
                              RaisedButton(
                                child: Text("Ok"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              )
                            ]),
                          );
                        });
                  })
            ],
            title: Text("Analysis")),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(top: 10, left: 5),
            child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 22.0, bottom: 20),
                  child: LineChart(LineChartData(
                      maxX: 1,
                      // widget.experiment.settings.vertexVoltage,
                      minX: 0,
                      // widget.experiment.settings.lowVoltage,
                      clipData: FlClipData.all(),
                      lineBarsData: [dataL, dataR],
                      axisTitleData: FlAxisTitleData(
                        show: true,
                        leftTitle: AxisTitle(
                            showTitle: true,
                            titleText: widget.experiment.settings.gainSetting == GainSettings.nA10 ? "Current/nA" : "Current/µA",
                            textStyle: TextStyle(fontStyle: FontStyle.italic, color: Colors.black)),
                        bottomTitle:
                        AxisTitle(showTitle: true, titleText: "Potential/V", textStyle: TextStyle(fontStyle: FontStyle.italic, color: Colors.black)),
                        topTitle: AxisTitle(
                            showTitle: true, titleText: "Current Vs Potential", textStyle: TextStyle(fontStyle: FontStyle.italic, color: Colors.black)),
                      ))),
                ),
              ),
//              ExperimentSettingsValues(settings: widget.experiment.settings),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                RaisedButton(
                    color: Colors.blue,
                    onPressed: () async {
                      await showDialog(context: context, builder: (BuildContext context) => FileNamePopup(onSave: saveLocally));
                    },
                    child: Text(
                      "Save",
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    )),
                RaisedButton(
                    color: Colors.blue,
                    child: Text("Start", style: TextStyle(color: Colors.white, fontSize: 15)),
                    onPressed: sweepStatBTConnection == null
                        ? null
                        : () {
                      sweepStatBTConnection.writeToSweepStat('.');
                    }),
                RaisedButton(
                    color: Colors.blue,
                    onPressed: () async {
                      await shareFiles();
                    },
                    child: Text("Share", style: TextStyle(color: Colors.white, fontSize: 15))),
                Builder(
                    builder: (context) => RaisedButton(
                        color: Colors.blue,
                        onPressed: () {
                          bluetooth(context);
                        },
                        child: Text("Bluetooth", style: TextStyle(color: Colors.white, fontSize: 15))))
              ]),
            ]),
          ),
        ));
  }
}
