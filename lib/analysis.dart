import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:permission_handler/permission_handler.dart';

const Set<String> EXPECTED_SETTINGS = {
  "initalVoltage",
  "highVoltage",
  "lowVoltage",
  "finalVoltage",
  "polarity",
  "scanRate",
  "sweepSegments",
  "smapleInterval",
  "autoSens", // TODO: This might be optional
  "finalE", // TODO: This might be optional
  "auxRecord", // TODO: This might be optional
};

const Map<String, Type> EXPECTED_SETTINGS_TYPE = {
  "initalVoltage": double,
  "highVoltage": double,
  "lowVoltage": double,
  "finalVoltage": double,
  "polarity": bool,
  "scanRate": double,
  "sweepSegments": double,
  "smapleInterval": double,
  "autoSens": bool, // TODO: This might be optional
  "finalE": bool, // TODO: This might be optional
  "auxRecord": bool // TODO: This might be optional
};

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
              ),
              RaisedButton(
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      Future<bool> saved =
                      widget.onSave(_textController.value.toString());
                      saved.then((bool didSave) {
                        setState(() {
                          saving = false;
                          saveStatus = didSave;
                        });
                      });
                      setState(() {
                        saving = true;
                      });
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

class AnalysisScreen extends StatefulWidget {
  /*
    It seems like everything is through shared preferences
  */
  final SharedPreferences prefs;

  const AnalysisScreen({Key key, this.prefs}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _AnalysisScreenState();
  }
}

Widget EnabledSettings(settings) {
  return Column(
    children: [
      Row(
        children: [
          Text("Initial Voltage: ${settings["initalVoltage"]} V"),
          Text("High Voltage: ${settings["highVoltage"]} V")
        ],
      ),
      Row(
        children: [
          Text("Low Voltage: ${settings["lowVoltage"]} V"),
          Text("Final Voltage: ${settings["finalVoltage"]} V"),
        ],
      ),
      Row(
        children: [
          Text(
              "Initial Polarity: ${settings["polarity"] ? "Positive" : "Negative"}"),
          Text("Scan Rate: ${settings["scanRate"]} V/s"),
        ],
      ),
      Row(
        children: [
          Text("Sweep Segments: ${settings["sweepSegments"]}"),
          Text("Sample Interval: ${settings["sampleInterval"]} V"),
        ],
      ),
      Row(
        children: [
          Text("Sensitivity: ????"),
          Text("Final Voltage: ?????"),
        ],
      ),
    ],
  );
}

class _AnalysisScreenState extends State<AnalysisScreen> {
  Map<String, dynamic> settings;
  List<DataPoints> data = [];

  dynamic getPrefType(SharedPreferences prefs, String setting, Type type) {
    switch (type) {
      case bool:
        {
          try {
            return prefs.getBool(setting);
          } catch (FormatException) {
            print("There was an error parsing $setting");
            print("The raw value of $setting was ${prefs.get(setting)}");
            return null;
          }
        }
        break;
      case double:
        {
          try {
            return prefs.getDouble(setting);
          } catch (FormatException) {
            print("There was an error parsing $setting");
            print("The raw value of $setting was ${prefs.get(setting)}");
          }
        }
        break;
    }
  }

  Map<String, dynamic> parsePrefs(SharedPreferences prefs) {
    Set<String> settingsInStorage = prefs.getKeys();
    Map<String, dynamic> settingsBuilder = {};
    if (settingsInStorage.difference(EXPECTED_SETTINGS).isNotEmpty) {
      // TODO: Error handling
      // If you get here, there are settings missing
      print("Missing settings!");
      print('${settingsInStorage.difference(EXPECTED_SETTINGS)}');
    } else {
      for (int i = 0; i < EXPECTED_SETTINGS.length; i++) {
        String currentSetting = EXPECTED_SETTINGS.elementAt(i);
        settingsBuilder[EXPECTED_SETTINGS.elementAt(i)] = getPrefType(
            prefs, currentSetting, EXPECTED_SETTINGS_TYPE[currentSetting]);
      }
      return settingsBuilder;
    }
  }

  @override
  void initState() {
    if (widget.prefs != null) {
      settings = parsePrefs(widget.prefs);
      print(settings);
    }
    super.initState();
  }

  Future<bool> saveLocally(String fileName) async {
    // TODO
    return true;
  }

  int i = 0; // TODO: temp remove, later
  Widget build(BuildContext context) {
    List<charts.Series<DataPoints, num>> chartSeries = [
      new charts.Series<DataPoints, double>(
        id: 'Sales',
        domainFn: (DataPoints sales, _) => sales.x,
        measureFn: (DataPoints sales, _) => sales.y,
        data: data,
      )
    ];
    return Scaffold(
        body: Column(
          children: [
            Expanded(child: charts.LineChart(chartSeries, animate: true)),
            EnabledSettings(settings),
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
                        data.add(new DataPoints(i + 1.0, sin(i + 1.0)));
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
                      PermissionStatus canSave = await Permission.storage.status;
                      if (!canSave.isGranted) {
                        PermissionStatus isGranted =
                        await Permission.storage.request();
                        if (!isGranted.isGranted) {
                          // We asked for storage and they denied
                          // okay, so just exit
                          return;
                        }
                      }
                      showDialog(
                          context: context,
                          builder: (BuildContext context) =>
                              FileNamePopup(onSave: saveLocally));
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
