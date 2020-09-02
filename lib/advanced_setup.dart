import 'package:flutter/material.dart';
import 'experiment_settings.dart';

// NOTE: I'm using the main function and the MyApp class for testing until we have a main page implemented
void main() {
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MaterialApp(
        title: 'Advanced Setup',
        home: Scaffold(
          appBar: AppBar(title: Text('Advanced Setup')),
          body: SetupForm(),
        )
      )
    );
  }
}

/*
  SetupForm: The main form for entering/validating data
*/
class SetupForm extends StatefulWidget {
  const SetupForm({Key key}) : super(key: key);
  @override
  _SetupFormState createState() => _SetupFormState();
}

class _SetupFormState extends State<SetupForm> {
  final _formKey = GlobalKey<FormState>(); // formkey for form
  static ExperimentSettings experimentSettings = new ExperimentSettings(); // ExperimentSettings class to save data
  // List of inputs for each field necessary
  final List<Widget> inputs = [
    new ValueInput('Initial Voltage', (double d)=>{experimentSettings.initialVoltage=d}, 'V'),
    new ValueInput('High Voltage', (double d)=>{experimentSettings.highVoltage=d}, 'V'),
    new ValueInput('Low Voltage', (double d)=>{experimentSettings.lowVoltage=d}, 'V'),
    new ValueInput('Final Voltage', (double d)=>{experimentSettings.finalVoltage=d}, 'V'),
    new ValueInput('Scan Rate', (double d)=>{experimentSettings.scanRate=d}, 'V/s'),
    new ValueInput('Sweep Segments', (double d)=>{experimentSettings.sweepSegments=d}, ''),
    new ValueInput('Sample Interval', (double d)=>{experimentSettings.sampleInterval=d}, 'V'),
    new CheckInput(text: 'isAutoSense', callback: (bool v)=>{experimentSettings.isAutoSens=v}),
    new CheckInput(text: 'isFinalE', callback: (bool v)=>{experimentSettings.isFinalE=v}),
    new CheckInput(text: 'isAuxRecording', callback: (bool v)=>{experimentSettings.isAuxRecording=v})
  ];

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        children: <Widget>[
          ...inputs,
          RaisedButton(
            onPressed: () {
              // First validate that value inputs are all doubles
              if (_formKey.currentState.validate()){
                try {
                  // If value inputs are doubles, load them into the Experiment Settings with save
                  _formKey.currentState.save();
                  print(experimentSettings);
                }catch (e){
                  // Mainly used for is lowVoltage > highVoltage (VoltageException)
                  Scaffold.of(context).showSnackBar(SnackBar(content: Text(e.errMsg())));
                }
              }
            },
            child: Text('Run Test'),)
        ]
      ),
    );
  }
}

// Stateful widget for controlling checkboxes
class CheckInput extends StatefulWidget {
  final String text; // Text to display with checkbox
  final Function callback; // Callback for when checkbox is changed
  const CheckInput({Key key, @required this.text, @required this.callback}) : super(key: key);
  @override
  CheckInputState createState() => CheckInputState();
}

class CheckInputState extends State<CheckInput> {
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
     return CheckboxListTile(
      title: Text(widget.text),
      value: _isChecked,
      onChanged: (bool value) {
        widget.callback(value);
        setState((){
          _isChecked = _isChecked ? false : true;
        });
      },);
  }

}

/*
  Stateless Widget for value inputs
  Validates on formKey.currentState.validate()
  Calls callback with double of input on formKey.currentState.save()
*/
class ValueInput extends StatelessWidget {
  ValueInput(this.text, this.callback, this.units);
  final String text, units; // Text is displayed name, units is the displayed unit val at end
  final Function callback; // Callback called on save

  @override
  Widget build(BuildContext buildCotext){
    return Row(
      children: <Widget>[
        Expanded(
          child:Text(text + ":")
        ),
        Expanded(child: 
          TextFormField(
            validator: (String value) {
              if (value.isEmpty){
                return 'Please Enter a Value';
              } else {
                try {
                  double.parse(value);
                  return null;
                } catch (e){
                  return 'Enter a valid number';
                }
              }
            },
            onSaved: (String val){
              callback(double.parse(val));
            }
          ,)
        ),
        Expanded(
          child: Text(units)
        )
      ],
    );
  }
}
