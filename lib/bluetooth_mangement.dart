import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

FlutterBlue flutterBlue = FlutterBlue.instance;

class BlueToothSelection extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _BlueToothSelectionState();
  }
}

class _BlueToothSelectionState extends State<BlueToothSelection> {
  @override
  void initState() {
    flutterBlue.startScan(timeout: Duration(seconds: 4));

    var subscription = flutterBlue.scanResults.listen((results) {
      // do something with scan results
      for (ScanResult r in results) {
        print('${r.device.name} found! rssi: ${r.rssi}');
      }
    });

    flutterBlue.stopScan();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return null;
  }
}
