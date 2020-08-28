import 'package:flutter/cupertino.dart';

class AnalysisScreen extends StatefulWidget {
  final String highVoltage; // The highest possible voltage
  final String lowVoltage; // The lowest possible voltage
  final String finalVoltage; // The last recorded voltage
  final String polarity; // The polarity (?)
  final String scanRate; // The time between scanning
  final String sweepSegments; // Not sure TODO
  final String sampleInterval; // Not sure TODO
  final bool autoSens; // TODO
  final bool finalE; // TODO
  final bool auxRecord; // TODO

  const AnalysisScreen({Key key, this.highVoltage, this.lowVoltage,
    this.finalVoltage, this.polarity, this.scanRate, this.sweepSegments,
    this.sampleInterval, this.autoSens, this.finalE, this.auxRecord
  }) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _AnalysisScreenState();
  }
}

class _AnalysisScreenState extends State<AnalysisScreen> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }

}