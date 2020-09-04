import 'package:path_provider/path_provider.dart';
import 'dart:io';

// A class for holding experiment settings variables
class ExperimentSettings {
  double _initialVoltage, highVoltage, lowVoltage, finalVoltage, scanRate, sweepSegments, sampleInterval;
  bool isAutoSens, isFinalE, isAuxRecording, isPositivePolarity;

  ExperimentSettings({initialVoltage=0.0, highVoltage=0.01, lowVoltage=0.0, finalVoltage=0.0, scanRate=0.0, 
                      sweepSegments=0.0, sampleInterval=0.0, isAutoSens=false, isFinalE=false,
                      isAuxRecording=false}){
      this.isPositivePolarity = initialVoltage >= 0.0 ? true : false;
      _initialVoltage = initialVoltage;
      this.highVoltage = highVoltage;
      this.lowVoltage = lowVoltage;
      this.finalVoltage = finalVoltage;
      this.scanRate = scanRate;
      this.sweepSegments = sweepSegments;
      this.sampleInterval = sampleInterval;
      this.isAutoSens = isAutoSens;
      this.isFinalE = isFinalE;
      this.isAuxRecording = isAuxRecording;
  }

  // Whenever initialVoltage is set, determine is polarity positive or negative
  set initialVoltage (double volt) {
    this.isPositivePolarity = volt >= 0.0 ? true : false;
    this._initialVoltage = volt;
  }

  // getter for initialVoltage
  double get initialVoltage {
    return _initialVoltage;
  }

  // toString formats like a csv file for ease of writing to file
  @override
  String toString () {
    String firstRow = 'initialVoltage,highVoltage,lowVoltage,finalVoltage,polarityToggle,scanRate,sweepSegments,sampleInterval,isAutoSens,isFinalE,isAuxRecording\n';
    String secondRow = _initialVoltage.toString() + ',' + highVoltage.toString() + ',' + lowVoltage.toString() + ',' + finalVoltage.toString() + ',' 
                      + (isPositivePolarity ? 'Positive' : 'Negative') + ',' + scanRate.toString() + ',' + sweepSegments.toString() + ',' + sampleInterval.toString() +',' + isAutoSens.toString() + ',' + isFinalE.toString() + ',' + isAuxRecording.toString();
    return firstRow + secondRow;
  }

  /*
    Method writes current object to file on device
    source: https://pub.dev/packages/path_provider
    Returns true if saved and false if file with name exists
  */
  Future<bool> writeToFile (String fileName) async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    Directory experimentDir = Directory(appDocDir.path+'/experiment_settings/');
    if (!await experimentDir.exists()){
      experimentDir = await experimentDir.create();
    }
    
    File experimentFile = new File(experimentDir.path + '/' + fileName + '.csv');
    if (await experimentFile.exists()){
      return false;
    }
    await experimentFile.writeAsString(this.toString());
    return true;
  }

}
