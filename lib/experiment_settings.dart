import 'package:path_provider/path_provider.dart';
import 'dart:io';

enum GainSettings {nA10, uA1, mA1}
extension GainExtension on GainSettings {

  String describeEnum() {
    switch(this) {
      case GainSettings.nA10:
        return "10 nA/V";
      case GainSettings.mA1:
        return "1 mA/V";
      case GainSettings.uA1:
        return "1 uA/V";

    }
    return null;
  }

  static GainSettings stringToEnum(String s) {
    switch(s) {
      case "10 nA/V":
        return GainSettings.nA10;
      case "1 mA/V":
        return GainSettings.mA1;
      case "1 uA/V":
        return GainSettings.uA1;
    }
    return null;

  }
}

enum Electrode {pseudoref, silver, calomel, hydrogen}

String variablesToBTString(List<double> variables){
  String returnString = "";
  for (int i = 0; i < variables.length; i++){
    String varString = variables[i].toString();
    if (varString.length > 8){
      varString = varString.substring(0, 8);
    } else if (varString.length < 8) {
      varString += new List<String>.generate((8 - varString.length), (i) => "0").reduce((value, element) => value += element);
    }
    returnString += String.fromCharCode(i + 65) + varString;
  }
  return returnString + "Z";
}


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

  String toBTString();

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
                       + gainSetting.describeEnum() + ',' + electrode.toString().split('.').last;
    return firstRow + secondRow;
  }
  

  @override
  String toBTString() {
    return variablesToBTString([runtime, initialVoltage, sampleInterval]);
  }
  

  @override
  void loadFromFile (File f){
    String fileData = f.readAsStringSync();
    List<String> fileInfo = fileData.split('\n')[1].split(',');
    initialVoltage = double.parse(fileInfo[0]);
    sampleInterval = double.parse(fileInfo[1]);
    runtime = double.parse(fileInfo[2]);
    gainSetting = GainExtension.stringToEnum(fileInfo[3]);
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
                       + gainSetting.describeEnum() + ',' + electrode.toString().split('.').last;
    return firstRow + secondRow;
  }


  @override
  String toBTString() {
    return variablesToBTString([initialVoltage, vertexVoltage, finalVoltage, scanRate]);
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
    gainSetting = GainExtension.stringToEnum(fileInfo[6]);
    electrode = Electrode.values.firstWhere((val)=> val.toString().split('.').last == fileInfo[7]);
  }



}
