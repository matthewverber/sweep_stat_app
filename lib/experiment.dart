import 'dart:io';
import 'dart:convert';

import 'package:fl_chart/fl_chart.dart';
import 'package:path_provider/path_provider.dart';
import 'experiment_settings.dart';

class Experiment {
  final ExperimentSettings settings;
  List<FlSpot> dataL = [FlSpot(0,0)];
  List<FlSpot> dataR = [FlSpot(0,0)];
  Directory experimentDir;

  Experiment(this.settings);

  // TODO What is this being used for?
  Future<Directory> getOrCreateCurrentDirectory() async {
    if (experimentDir == null) {
      Directory appDocDir = await getApplicationDocumentsDirectory();
      experimentDir = Directory(appDocDir.path);
    }
    if (!await experimentDir.exists()) {
      experimentDir = await experimentDir.create(recursive: true);
    }
    return experimentDir;
  }

  List<String> dataToString() {
    try {
      List<FlSpot> dataRCopy = [];
      dataRCopy.addAll(dataR);
      dataRCopy.insertAll(0, dataL);
      List<String> stringified = dataRCopy.map((dataPoint) => "${dataPoint.x}, ${dataPoint.y}").toList();
      stringified.insert(0, "potential, current");
      return stringified;
    } catch (IOException) {
      return null;
    }
  }

  
  @override
  String toString() {
    String returnString;
    if (this.settings is VoltammetrySettings){
      VoltammetrySettings v = this.settings;
      returnString = 'Cyclic Voltammetry\n' +
                      'Gain Setting: ' + v.gainSetting.toString().split('.').last + '\n' +
                      'Ref. Electrode: ' + v.electrode.toString().split('.').last + '\n\n' +
                      'Init E (V) = ' + v.initialVoltage.toString() + '\n' +
                      'Vertex E (V) = ' + v.vertexVoltage.toString() + '\n' +
                      'Final E (V) = ' + v.finalVoltage.toString() + '\n' +
                      'Scan Rate (V/s) = ' + v.scanRate.toString() + '\n' +
                      'Sweep Segments = ' + v.sweepSegments.toString() + '\n' +
                      'Sample Interval (V) = ' + v.sampleInterval.toString() + '\n\n';
    } else {
      AmperometrySettings a = this.settings;
      returnString = 'Amperometry\n' + 
                      'Gain Setting: ' + a.gainSetting.toString().split('.').last + '\n' +
                      'Ref. Electrode: ' + a.electrode.toString().split('.').last + '\n\n' +
                      'Initial E (V) = ' + a.initialVoltage.toString() + '\n' +
                      'Sample Interval (V) = ' + a.sampleInterval.toString() + '\n' +
                      'Runtime (S) = ' + a.runtime.toString() + '\n\n';
    }

    returnString += this.dataToString().reduce((value, element) => value + element + '\n');
    return returnString;

  }

  String saveConfig() {
    return this.settings.toString();
  }

  Future<bool> saveExperiment(String fileName) async {
    String dirName = this.settings is VoltammetrySettings ? 'cv_experiments' : 'amp_experiments';
    Directory appDocDir = await getApplicationDocumentsDirectory();
    Directory experimentDir = Directory(appDocDir.path+'/' + dirName + '/');
    if (!await experimentDir.exists()){
      experimentDir = await experimentDir.create();
    }

    File experimentFile = new File(experimentDir.path + fileName + '.csv');
    if (await experimentFile.exists()) return false;

    await experimentFile.writeAsString(this.toString());
    return true;
  }

  static Future<Experiment> loadFromFile(File f, String expType) {
    ExperimentSettings eS;
    if (expType == 'CV'){

    }
    Experiment e = new Experiment(eS);
  }


}

class DataPoints {
  final double potential;
  final double current;

  DataPoints(this.potential, this.current);
}

