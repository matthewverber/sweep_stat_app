import 'package:flutter/material.dart';
import 'experiment_settings.dart';
import 'dart:io';

// NOTE: I'm using the main function and the MyApp class for testing until we have a main page implemented
void main() {
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Advanced Setup',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.blue,
          textTheme: ButtonTextTheme.primary
        )
      ),
      home: AdvancedSetup()
    );

  }
}

class AdvancedSetup extends StatelessWidget {
  final File f;
  AdvancedSetup([this.f]);
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('Advanced Setup'),
        leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: (){
                  Navigator.pop(context);
                },
              )
        ),
      body: SetupForm(file: f)
    );
  }
}

/*
  SetupForm: The main form for entering/validating data
*/
class SetupForm extends StatefulWidget {
  final File file;
  const SetupForm({Key key, this.file}) : super(key: key);
  @override
  _SetupFormState createState() => _SetupFormState();
}

class _SetupFormState extends State<SetupForm> {
  final _formKey = GlobalKey<FormState>(); // formkey for form
  static VoltammetrySettings experimentSettings = new VoltammetrySettings(); // ExperimentSettings class to save data
  // List of inputs for each field necessary
  List inputs;
  String directoryPath;
  File file;

  @override
  void initState(){
    super.initState();
    file = widget.file;
    if (file != null){
      directoryPath = file.path.substring(0, file.path.lastIndexOf('/')+1);
      experimentSettings.loadFromFile(file);
      inputs = [
        TextFormField(
          decoration: InputDecoration(
            labelText: 'File Name'
          ),
          keyboardType: TextInputType.number,
          initialValue: file.path.split('/').last.split('.').first,
          validator: (String value) {
            if (value.isEmpty){
              return 'Please Enter a Value';
            } 
            return null;
          },
          onSaved: (String val) {
           file = file.renameSync(directoryPath + val + '.csv');
          }
        ),
        new ValueInput('Initial Voltage (V)', (double d)=>{experimentSettings.initialVoltage=d}, experimentSettings.initialVoltage.toString()),
        new ValueInput('Vertex Voltage (V)', (double d)=>{experimentSettings.vertexVoltage=d}, experimentSettings.vertexVoltage.toString()),
        new ValueInput('Final Voltage (V)', (double d)=>{experimentSettings.finalVoltage=d}, experimentSettings.finalVoltage.toString()),
        new ValueInput('Scan Rate (V/s)', (double d)=>{experimentSettings.scanRate=d}, experimentSettings.scanRate.toString()),
        new ValueInput('Sweep Segments', (double d)=>{experimentSettings.sweepSegments=d}, experimentSettings.sweepSegments.toString()),
        new ValueInput('Sample Interval (V)', (double d)=>{experimentSettings.sampleInterval=d}, experimentSettings.sampleInterval.toString()),
      ];
    } else {
      inputs = [
        new ValueInput('Initial Voltage (V)', (double d)=>{experimentSettings.initialVoltage=d}, ''),
        new ValueInput('Vertex Voltage (V)', (double d)=>{experimentSettings.vertexVoltage=d}, ''),
        new ValueInput('Final Voltage (V)', (double d)=>{experimentSettings.finalVoltage=d}, ''),
        new ValueInput('Scan Rate (V/s)', (double d)=>{experimentSettings.scanRate=d}, ''),
        new ValueInput('Sweep Segments', (double d)=>{experimentSettings.sweepSegments=d}, ''),
        new ValueInput('Sample Interval (V)', (double d)=>{experimentSettings.sampleInterval=d}, ''),
      ];
    }
  }


  // Method for loading variables in experimentSettings
  // Returns true if inputs valid, false if not
  bool _loadVariables(){
    // First validate that value inputs are all doubles
    if (_formKey.currentState.validate()){
        // If value inputs are doubles, load them into the Experiment Settings with save
        _formKey.currentState.save();

        return true;
    }
    return false;
  }


  // Method for saving to new file with dialog box
  Future<void> _saveNewFile() async{
    // Get name from a dialog box
    String name = await _showFileDialog(context);
     // Make sure name is valid
    if (name != null){
    // Write to file and alert user using experimentSettings' writeToFile
      if (await experimentSettings.writeToFile(name)){
        Scaffold.of(context).showSnackBar(SnackBar(content: Text(name + ' saved!')));
      } else {
      // If false returned, file already exists
        Scaffold.of(context).showSnackBar(SnackBar(content: Text(name + ' already exists')));
      }  
    }
  }

  // Note: much of this from following tutorial: https://www.youtube.com/watch?v=FGfhnS6skMQ&ab_channel=RetroPortalStudio
  // Method for creating the Dialog allowing a user to input a file name
  Future<String> _showFileDialog (BuildContext context){
    TextEditingController controller = new TextEditingController();
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Enter File Name'),
          content: TextField(controller: controller),
          actions: [
            MaterialButton(
              child: Text('Save'),
              onPressed: (){
                Navigator.of(context).pop(controller.text.toString());
              },
            ),
            MaterialButton(
              child: Text('Cancel'),
              onPressed: (){
                Navigator.of(context).pop();
              },)
          ],
        );
      });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Center(
          child: FractionallySizedBox(
            widthFactor: 0.9,
            child: ListView(
            children: <Widget>[
              ...inputs,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(right: 10),
                      child:RaisedButton(
                      onPressed: _loadVariables,
                      child: Text('Run Test')
                      )
                    )
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: RaisedButton(
                      onPressed: () async{
                        // if inputs valid
                        if(_loadVariables()){
                          if (file == null){
                            _saveNewFile();
                          } else {
                            if (await experimentSettings.overwriteFile(file)){
                              Scaffold.of(context).showSnackBar(SnackBar(content: Text('Overwrote file')));
                            } else {
                              Scaffold.of(context).showSnackBar(SnackBar(content: Text('Could not locate file')));
                            }  
                          }
                        }
                      },
                      child: Text('Save')
                    )
                  )
                    
                  )
                ]
              ),
              if (file != null) 
                RaisedButton(
                  onPressed: _saveNewFile,
                  child: Text('Save as New Config')
                  )
            ]
          ),
        )
      )
    );
  }
}

/*
  Validates on formKey.currentState.validate()
  Calls callback with double of input on formKey.currentState.save()
*/
class ValueInput extends StatelessWidget {
  ValueInput(this.text, this.callback, this.value);
  final String text, value; // Text is displayed name, units is the displayed unit val at end
  final Function callback; // Callback called on save

  @override
  Widget build(BuildContext context){
    return TextFormField(
        decoration: InputDecoration(
          labelText: text
        ),
        keyboardType: TextInputType.number,
        initialValue: value,
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
        });
  }
}
