import 'package:fl_chart/fl_chart.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'experiment_settings.dart';

class Experiment {
  final ExperimentSettings settings;
  List<FlSpot> dataL = [FlSpot(0,0)];
  List<FlSpot> dataR = [FlSpot(0,0)];
  Directory experimentDir;

  Experiment(this.settings);

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

  String saveConfig() {
    return this.settings.toString();
  }

  saveExperiment() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    Directory experimentDir = Directory(appDocDir.path+'/' + 'temper' + '/');
    if (!await experimentDir.exists()){
      experimentDir = await experimentDir.create();
    }

    File experimentFile = new File(experimentDir.path + 'temper/temp' + '.csv');
    await experimentFile.create(recursive: true);
    await experimentFile.writeAsString(this.toString());
    return true;
  }
}

class DataPoints {
  final double potential;
  final double current;

  DataPoints(this.potential, this.current);
}

