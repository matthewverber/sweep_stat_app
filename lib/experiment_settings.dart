import 'package:path_provider/path_provider.dart';
import 'dart:io';

enum GainSettings {macro, micro}
enum Electrode {pseudoref, silver, calomel, hydrogen}


abstract class ExperimentSettings {
  double initialVoltage, sampleInterval;
  GainSettings gainSetting;
  Electrode electrode;

  ExperimentSettings(this.initialVoltage, this.sampleInterval, this.gainSetting, this.electrode);

    /*
    Method writes current object to file on device
    source: https://pub.dev/packages/path_provider
    Returns true if saved and false if file with name exists
  */
  Future<bool> writeToFile (String fileName, String dirName) async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    Directory experimentDir = Directory(appDocDir.path+'/' + dirName + '/');
    if (!await experimentDir.exists()){
      experimentDir = await experimentDir.create();
    }
    
    File experimentFile = new File(experimentDir.path + fileName + '.csv');
    if (await experimentFile.exists()){
      return false;
    }

    await experimentFile.writeAsString(this.toString());
    return true;
  }


  // Load the data from a file into the object synchronously
  void loadFromFile (File f);

    // Overwrites data to existing file
  Future<bool> overwriteFile (File f) async {
    if (await f.exists()){
      await f.writeAsString(this.toString());
      return true;
    }
    return false;
  }


}

class AmperometrySettings extends ExperimentSettings {
  double runtime;

  AmperometrySettings({runtime, initialVoltage, sampleInterval, gainSetting, electrode}): super(initialVoltage, sampleInterval, gainSetting, electrode){
    this.runtime = runtime;
  }

  // toString formats like a csv file for ease of writing to file
  @override
  String toString () {
    String firstRow = 'initialVoltage,sampleInterval,runtime,gainSetting,electrode\n';
    String secondRow = initialVoltage.toString() + ',' +  sampleInterval.toString() + ',' + runtime.toString() + ','
                       + gainSetting.toString().split('.').last + ',' + electrode.toString().split('.').last;
    return firstRow + secondRow;
  }
  
  

  @override
  void loadFromFile (File f){
    String fileData = f.readAsStringSync();
    List<String> fileInfo = fileData.split('\n')[1].split(',');
    initialVoltage = double.parse(fileInfo[0]);
    sampleInterval = double.parse(fileInfo[1]);
    runtime = double.parse(fileInfo[2]);
    gainSetting = GainSettings.values.firstWhere((val)=> val.toString().split('.').last == fileInfo[3]);
    electrode = Electrode.values.firstWhere((val)=> val.toString().split('.').last == fileInfo[4]);
  }
  

}

// A class for holding experiment settings variables
class VoltammetrySettings extends ExperimentSettings{
  double vertexVoltage, finalVoltage, scanRate, sweepSegments;

  VoltammetrySettings({initialVoltage, vertexVoltage, finalVoltage, scanRate, 
                      sweepSegments, sampleInterval, gainSetting, electrode}): super(initialVoltage, sampleInterval, gainSetting, electrode){
      this.vertexVoltage = vertexVoltage;
      this.finalVoltage = finalVoltage;
      this.scanRate = scanRate;
      this.sweepSegments = sweepSegments;
  }

  // toString formats like a csv file for ease of writing to file
  @override
  String toString () {
    String firstRow = 'initialVoltage,vertexVoltage,finalVoltage,scanRate,sweepSegments,sampleInterval,gainSetting,electrode\n';
    String secondRow = initialVoltage.toString() + ',' + vertexVoltage.toString()  + ',' + finalVoltage.toString() + ',' 
                       + scanRate.toString() + ',' + sweepSegments.toString() + ',' + sampleInterval.toString() + ','
                       + gainSetting.toString().split('.').last + ',' + electrode.toString().split('.').last;
    return firstRow + secondRow;
  }



  // Load the data from a file into the object synchronously
  void loadFromFile (File f){
    String fileData = f.readAsStringSync();
    List<String> fileInfo = fileData.split('\n')[1].split(',');
    initialVoltage = double.parse(fileInfo[0]);
    vertexVoltage = double.parse(fileInfo[1]);
    finalVoltage = double.parse(fileInfo[2]);
    scanRate = double.parse(fileInfo[3]);
    sweepSegments = double.parse(fileInfo[4]);
    sampleInterval = double.parse(fileInfo[5]);
    gainSetting = GainSettings.values.firstWhere((val) => val.toString().split('.').last == fileInfo[6]);
    electrode = Electrode.values.firstWhere((val)=> val.toString().split('.').last == fileInfo[7]);
  }

}
