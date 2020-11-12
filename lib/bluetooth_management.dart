import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_blue/flutter_blue.dart';

import 'bluetooth_connection.dart';
import 'main.dart';

FlutterBlue flutterBlue = FlutterBlue.instance;

class BlueToothSelection extends StatefulWidget {
  /*
   * Source : https://github.com/pauldemarco/flutter_blue/blob/master/example/lib/main.dart
   */
  @override
  State<StatefulWidget> createState() {
    return _BlueToothSelectionState();
  }
}

class _BlueToothSelectionState extends State<BlueToothSelection> {
  @override
  void initState() {
    FlutterBlue.instance.startScan(timeout: Duration(seconds: 4));
    super.initState();
  }

  @override
  void dispose() {
    FlutterBlue.instance.stopScan();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        "Bluetooth Devices",
        style: TextStyle(fontSize: 22),
        textAlign: TextAlign.center,
      ),
      content: Scaffold(
          backgroundColor: Colors.white,
          body: RefreshIndicator(
            onRefresh: () => FlutterBlue.instance.startScan(timeout: Duration(seconds: 4)),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Divider(),
                  StreamBuilder<List<dynamic>>(
                    stream: FlutterBlue.instance.scanResults,
                    // stream: null,
                    initialData: [],
                    builder: (c, snapshot) => Column(
                      children: snapshot.data.map((r) {
                        if (r.device.name.isNotEmpty) {
                          return Card(
                            child: ListTile(
                              title: Text(
                                r.device.name,
                                textAlign: TextAlign.center,
                              ),
                              onTap: () async {
                                Navigator.pop(context, r.device);
                                //SweepStatBTConnection connection = await SweepStatBTConnection.createSweepBTConnection(r.device, () {});
                                //Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => MyHomePage()));
                              },
                            ),
                          );
                        } else {
                          return Container();
                        }
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          floatingActionButton: StreamBuilder<bool>(
            stream: FlutterBlue.instance.isScanning,
            initialData: false,
            builder: (c, snapshot) {
              if (snapshot.data) {
                return FloatingActionButton(
                  child: Icon(Icons.stop),
                  onPressed: () => FlutterBlue.instance.stopScan(),
                  backgroundColor: Colors.red,
                );
              } else {
                return FloatingActionButton(child: Icon(Icons.search), onPressed: () => FlutterBlue.instance.startScan(timeout: Duration(seconds: 4)));
              }
            },
          )),
      // ,,
    );
  }
}
