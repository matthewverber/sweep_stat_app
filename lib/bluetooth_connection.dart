import 'dart:async';

import 'package:flutter_blue/flutter_blue.dart';

const String sweepstatServiceUUID = "0000FFE0-0000-1000-8000-00805F9B34FB";
const String sweepstatCharacteristicUUID = "0000FFE1-0000-1000-8000-00805F9B34FB";

class SweepStatBTConnection {
  BluetoothDevice device;
  BluetoothCharacteristic characteristic;
  BluetoothDeviceState bluetoothDeviceState;
  Function disconnectCallback;
  StreamSubscription notifyListener;
  StreamSubscription stateListener;

  SweepStatBTConnection._(BluetoothDevice device, Function disconnectCallback){
    this.device = device;
    this.disconnectCallback = disconnectCallback;
    bluetoothDeviceState = BluetoothDeviceState.connected;
    stateListener = device.state.listen((BluetoothDeviceState state) async{
      if(state == BluetoothDeviceState.disconnected || state == BluetoothDeviceState.disconnecting){
        await endConnection();
      } else {
        bluetoothDeviceState = state;
        print(this);
      }
    });
  }

  Future<void> endConnection() async {
    if (notifyListener != null) notifyListener.cancel();
    if (stateListener != null) stateListener.cancel();
    await device.disconnect();
    disconnectCallback();
    print('connection ended');
  }

  Future<void> writeToSweepStat(String message) async{
    await characteristic.write(message.codeUnits);
  }

  Future<void> addNotifyListener(Function callback) async{
    await characteristic.setNotifyValue(true);
    notifyListener = characteristic.value.listen(callback);
  }

  static Future<SweepStatBTConnection> createSweepBTConnection(BluetoothDevice d, Function c) async{
    SweepStatBTConnection sweepConnection = new SweepStatBTConnection._(d, c);
    // Acquire correct characteristic
    List<BluetoothService> services = await d.discoverServices();

    for (BluetoothService service in services){
      if (service.uuid == Guid(sweepstatServiceUUID)){
          for(BluetoothCharacteristic c in service.characteristics) {
            if (c.uuid == Guid(sweepstatCharacteristicUUID)){
              sweepConnection.characteristic = c;
              break;
            }
          }
      }
    }

    print('services found');
    // Make characteristic exists
    if (sweepConnection.characteristic == null) return null;
    

    return sweepConnection;
  }
}

/*
Future<bool> attachCallback(FlutterBlue flutterBlue, BluetoothDevice device, String serviceUUID, String characteristicUUID, Function callback) async {
  // Check to see if device available
  List<BluetoothDevice> connectedDevices = await flutterBlue.connectedDevices;
  if (!connectedDevices.contains(device)) return false;

  // Acquire correct characteristic
  List<BluetoothService> services = await device.discoverServices();
  BluetoothCharacteristic char;

  for (BluetoothService service in services){
    if (service.uuid == Guid(serviceUUID)){
        for(BluetoothCharacteristic c in service.characteristics) {
          if (c.uuid == Guid(characteristicUUID)){
            char = c;
            break;
          }
        }
    }

  }
  // Make sure service and characteristics exist
  if (char == null) return false;

  await char.setNotifyValue(true);
  char.value.listen(callback);
  
  return true;
}

Future<bool> sendMessage()

Future<void> caller(FlutterBlue instance, BluetoothDevice device) async{
  List<String> s = [];
  Utf8Decoder dec = Utf8Decoder();
  Function callback = (List<int> ints){
    String newString = dec.convert(ints);
    s.add(newString);
    print(newString);
    if (newString.contains('\$')) {
      print(s.join(''));
    }
  };

  await bluetoothExperiment(instance, device, '.', sweepstatServiceUUID, sweepstatCharacteristicUUID, callback);
}*/