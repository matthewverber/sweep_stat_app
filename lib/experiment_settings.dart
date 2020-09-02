import 'package:path_provider/path_provider.dart';
import 'dart:io';

// A class for holding experiment settings variables
class ExperimentSettings {
  double _initialVoltage, _highVoltage, _lowVoltage, finalVoltage, scanRate, sweepSegments, sampleInterval;
  bool isAutoSens, isFinalE, isAuxRecording, isPositivePolarity;

  ExperimentSettings({initialVoltage=0.0, highVoltage=0.01, lowVoltage=0.0, finalVoltage=0.0, scanRate=0.0, 
                      sweepSegments=0.0, sampleInterval=0.0, isAutoSens=false, isFinalE=false,
                      isAuxRecording=false}){
      if (highVoltage <= lowVoltage) throw new VoltageException();
      this.isPositivePolarity = initialVoltage >= 0.0 ? true : false;
      _initialVoltage = initialVoltage;
      _highVoltage = highVoltage;
      _lowVoltage = lowVoltage;
      this.finalVoltage = finalVoltage;
      this.scanRate = scanRate;
      this.sweepSegments = sweepSegments;
      this.sampleInterval = sampleInterval;
      this.isAutoSens = isAutoSens;
      this.isFinalE = isFinalE;
      this.isAuxRecording = isAuxRecording;
  }

  // Getters and setters for low/high voltage to ensure that low voltage is always lower than high voltage
  double get highVoltage {
    return _highVoltage;
  }

  set highVoltage (double volt) {
    if (volt <= _lowVoltage) throw new VoltageException();
    _highVoltage = volt;
  }

  double get lowVoltage {
    return _lowVoltage;
  }

  set lowVoltage (double volt) {
    if (volt > _highVoltage) throw new VoltageException();
    _lowVoltage = volt;
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
    TODO: testing saving and time it takes to save
  */
  void writeToFile (String fileName) async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    Directory experimentDir = Directory(appDocDir.path+'/experiment_directory/');
    if (!await experimentDir.exists()){
      experimentDir = await experimentDir.create();
    }
    
    File experimentFile = new File(experimentDir.path + '/' + fileName + '.csv');
    await experimentFile.writeAsString(this.toString());
  }

}

// Exception thrown when low voltage >= high voltage
class VoltageException implements Exception { 
   String errMsg() => 'Low Voltage must be less than High Voltage'; 
}  