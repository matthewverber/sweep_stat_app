import 'package:path_provider/path_provider.dart';
import 'dart:io';

// A class for holding experiment settings variables
class VoltammetrySettings {
  double initialVoltage, vertexVoltage, finalVoltage, scanRate, sweepSegments, sampleInterval;

  VoltammetrySettings({initialVoltage=0.0, vertexVoltage=0.01, lowVoltage=0.0, finalVoltage=0.0, scanRate=0.0, 
                      sweepSegments=0.0, sampleInterval=0.0}){
      this.initialVoltage = initialVoltage;
      this.vertexVoltage = vertexVoltage;
      this.finalVoltage = finalVoltage;
      this.scanRate = scanRate;
      this.sweepSegments = sweepSegments;
      this.sampleInterval = sampleInterval;
  }



  // Gets the values of the object in a list
  List getValuesList(){
    return [initialVoltage, vertexVoltage, finalVoltage, scanRate, sweepSegments, sampleInterval];
  }

  // toString formats like a csv file for ease of writing to file
  @override
  String toString () {
    String firstRow = 'initialVoltage,vertexVoltage,finalVoltage,scanRate,sweepSegments,sampleInterval\n';
    String secondRow = initialVoltage.toString() + ',' + vertexVoltage.toString()  + ',' + finalVoltage.toString() + ',' 
                       + scanRate.toString() + ',' + sweepSegments.toString() + ',' + sampleInterval.toString();
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


  // Overwrites data to existing file
  Future<bool> overwriteFile (File f) async {
    print(await f.exists());
    if (await f.exists()){
      await f.writeAsString(this.toString());
      return true;
    }
    return false;
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
  }

}
