import 'package:flutter/material.dart';
import 'package:sweep_stat_app/experiment_settings.dart';
import 'analysis.dart';
import 'experiment.dart';
import 'dart:io';
import 'package:share/share.dart';

// NOTE: I'm using the main function and the MyApp class for testing until we have a main page implemented
class AdvancedSetup extends StatelessWidget {
  final File f;
  final String t;

  AdvancedSetup([this.f, this.t]);

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Advanced Setup'),
        ),
        body: SetupForm(file: f, fileType: t));
  }
}

// Helper functions for checking if correct range
String voltValid(String num) {
  double n = double.parse(num);
  return (n >= -1.5 && n <= 1.5) ? null : "Enter a number between -1.5 and 1.5";
}

String segmentsValid(String num) {
  double n = double.parse(num);
  return n.floor() == n  && n > 0 ? null : "Must be an integer greater than 0";
}


/*
  SetupForm: The main form for entering/validating data
*/
class SetupForm extends StatefulWidget {
  final File file;
  final String fileType;

  const SetupForm({Key key, this.file, this.fileType}) : super(key: key);

  @override
  _SetupFormState createState() => _SetupFormState();
}

class _SetupFormState extends State<SetupForm> {
  final _formKey = GlobalKey<FormState>(); // formkey for form
  ExperimentSettings
      experimentSettings; // ExperimentSettings class to save data
  // List of inputs for each field necessary
  List inputs;
  File file;
  String expType;

  @override
  void initState() {
    super.initState();
    file = widget.file;
    if (file != null) {
      String directoryPath =
          file.path.substring(0, file.path.lastIndexOf('/') + 1);
      String fileName = file.path.split('/').last.split('.').first;
      TextFormField nameWidget = TextFormField(
          decoration: InputDecoration(labelText: 'File Name'),
          keyboardType: TextInputType.number,
          initialValue: fileName,
          validator: (String value) {
            if (value.isEmpty) {
              return 'Please Enter a Value';
            }
            return null;
          },
          onSaved: (String val) {
            if (val != fileName) {
              file = file.renameSync(directoryPath + val + '.csv');
            }
          });
      if (widget.fileType == 'CV') {
        VoltammetrySettings voltammetrySettings = new VoltammetrySettings();
        voltammetrySettings.loadFromFile(file);

        inputs = [
          nameWidget,
          new ValueInput(
              'Initial Voltage (V)',
              (double d) => {voltammetrySettings.initialVoltage = d},
              voltammetrySettings.initialVoltage.toString(),
              voltValid),
          new ValueInput(
              'Vertex Voltage (V)',
              (double d) => {voltammetrySettings.vertexVoltage = d},
              voltammetrySettings.vertexVoltage.toString(),
              voltValid),
          new ValueInput(
              'Final Voltage (V)',
              (double d) => {voltammetrySettings.finalVoltage = d},
              voltammetrySettings.finalVoltage.toString(),
              voltValid),
          new ValueInput(
              'Scan Rate (V/s)',
              (double d) => {voltammetrySettings.scanRate = d},
              voltammetrySettings.scanRate.toString(),
              null),
          new ValueInput(
              'Sweep Segments',
              (double d) => {voltammetrySettings.sweepSegments = d},
              voltammetrySettings.sweepSegments.toString(),
              segmentsValid),
          new ValueInput(
              'Sample Interval (V)',
              (double d) => {voltammetrySettings.sampleInterval = d},
              voltammetrySettings.sampleInterval.toString(),
              null),
          new DropDownInput(
              labelStrings: ['10 nA/V', '1 uA/V', '1 mA/V'],
              values: GainSettings.values.toList(),
              hint: 'Select Gain Setting',
              initialVal: voltammetrySettings.gainSetting,
              callback: (GainSettings g) =>
                  {voltammetrySettings.gainSetting = g}),
          new DropDownInput(
              labelStrings: [
                'Pseudo-Reference Electrode',
                'Silver/Silver Chloride Electrode',
                'Saturated Calomel',
                'Standard Hydrogen Electrode'
              ],
              values: Electrode.values.toList(),
              hint: 'Select Electrode',
              initialVal: voltammetrySettings.electrode,
              callback: (Electrode e) => {voltammetrySettings.electrode = e})
        ];
        experimentSettings = voltammetrySettings;
        expType = 'CV';
      } else {
        AmperometrySettings amperometrySettings = new AmperometrySettings();
        amperometrySettings.loadFromFile(file);
        inputs = [
          nameWidget,
          new ValueInput(
              'Initial Voltage (V)',
              (double d) => {amperometrySettings.initialVoltage = d},
              amperometrySettings.initialVoltage.toString(),
              voltValid),
          new ValueInput(
              'Sample Interval (V)',
              (double d) => {amperometrySettings.sampleInterval = d},
              amperometrySettings.sampleInterval.toString(),
              null),
          new ValueInput(
              'Run time (S)',
              (double d) => {amperometrySettings.runtime = d},
              amperometrySettings.runtime.toString(),
              null),
          new DropDownInput(
              labelStrings: ['10 nA/V', '1 uA/V', '1 mA/V'],
              values: GainSettings.values.toList(),
              hint: 'Select Gain Setting',
              initialVal: amperometrySettings.gainSetting,
              callback: (GainSettings g) =>
                  {amperometrySettings.gainSetting = g}),
          new DropDownInput(
              labelStrings: [
                'Pseudo-Reference Electrode',
                'Silver/Silver Chloride Electrode',
                'Saturated Calomel',
                'Standard Hydrogen Electrode'
              ],
              values: Electrode.values.toList(),
              hint: 'Select Electrode',
              initialVal: amperometrySettings.electrode,
              callback: (Electrode e) => {amperometrySettings.electrode = e})
        ];
        experimentSettings = amperometrySettings;
        expType = 'Amperometry';
      }
    } else {
      changeExperimentType('CV');
    }
  }

  void changeExperimentType(String type) {
    if (type != expType) {
      if (type == 'CV') {
        setState(() {
          expType = 'CV';
          VoltammetrySettings voltammetrySettings = new VoltammetrySettings();
          inputs = [
            new ValueInput('Initial Voltage (V)',
                (double d) => {voltammetrySettings.initialVoltage = d}, '', voltValid),
            new ValueInput('Vertex Voltage (V)',
                (double d) => {voltammetrySettings.vertexVoltage = d}, '', voltValid),
            new ValueInput('Final Voltage (V)',
                (double d) => {voltammetrySettings.finalVoltage = d}, '', voltValid),
            new ValueInput('Scan Rate (V/s)',
                (double d) => {voltammetrySettings.scanRate = d}, '', null),
            new ValueInput('Sweep Segments',
                (double d) => {voltammetrySettings.sweepSegments = d}, '', segmentsValid),
            new ValueInput('Sample Interval (V)',
                (double d) => {voltammetrySettings.sampleInterval = d}, '', null),
            new DropDownInput(
                labelStrings: ['10 nA/V', '1 uA/V', '1 mA/V'],
                values: GainSettings.values.toList(),
                hint: 'Select Gain Setting',
                callback: (GainSettings g) =>
                    {voltammetrySettings.gainSetting = g}),
            new DropDownInput(
                labelStrings: [
                  'Pseudo-Reference Electrode',
                  'Silver/Silver Chloride Electrode',
                  'Saturated Calomel',
                  'Standard Hydrogen Electrode'
                ],
                values: Electrode.values.toList(),
                hint: 'Select Electrode',
                callback: (Electrode e) => {voltammetrySettings.electrode = e})
          ];
          experimentSettings = voltammetrySettings;
        });
      } else if (type == 'Amperometry') {
        setState(() {
          expType = 'Amperometry';
          AmperometrySettings amperometrySettings = new AmperometrySettings();
          inputs = [
            new ValueInput('Initial Voltage (V)',
                (double d) => {amperometrySettings.initialVoltage = d}, '', voltValid),
            new ValueInput('Sample Interval (V)',
                (double d) => {amperometrySettings.sampleInterval = d}, '', null),
            new ValueInput('Run time (S)',
                (double d) => {amperometrySettings.runtime = d}, '', null),
            new DropDownInput(
                labelStrings: ['10 nA/V', '1 uA/V', '1 mA/V'],
                values: GainSettings.values.toList(),
                hint: 'Select Gain Setting',
                callback: (GainSettings g) =>
                    {amperometrySettings.gainSetting = g}),
            new DropDownInput(
                labelStrings: [
                  'Pseudo-Reference Electrode',
                  'Silver/Silver Chloride Electrode',
                  'Saturated Calomel',
                  'Standard Hydrogen Electrode'
                ],
                values: Electrode.values.toList(),
                hint: 'Select Electrode',
                callback: (Electrode e) => {amperometrySettings.electrode = e})
          ];
          experimentSettings = amperometrySettings;
        });
      }
    }
  }

  // Method for loading variables in experimentSettings
  // Returns true if inputs valid, false if not
  bool _loadVariables() {
    // First validate that value inputs are all doubles
    if (_formKey.currentState.validate()) {
      // If value inputs are doubles, load them into the Experiment Settings with save
      _formKey.currentState.save();

      return true;
    }
    return false;
  }

  // Method for saving to new file with dialog box
  Future<void> _saveNewFile() async {
    // Get name from a dialog box
    String name = await _showFileDialog(context);
    // Make sure name is valid
    if (name != null) {
      // Write to file and alert user using experimentSettings' writeToFile
      if (await experimentSettings.writeToFile(
          name, expType == 'CV' ? 'cv_configs' : 'amp_configs')) {
        Scaffold.of(context)
            .showSnackBar(SnackBar(content: Text(name + ' saved!')));
      } else {
        // If false returned, file already exists
        Scaffold.of(context)
            .showSnackBar(SnackBar(content: Text(name + ' already exists')));
      }
    }
  }

  // Note: much of this from following tutorial: https://www.youtube.com/watch?v=FGfhnS6skMQ&ab_channel=RetroPortalStudio
  // Method for creating the Dialog allowing a user to input a file name
  Future<String> _showFileDialog(BuildContext context) {
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
                onPressed: () {
                  Navigator.of(context).pop(controller.text.toString());
                },
              ),
              MaterialButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
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
          child: ListView(children: <Widget>[
            if (file == null)
              new DropdownButton(
                  value: expType,
                  onChanged: (String val) => changeExperimentType(val),
                  items: [
                    DropdownMenuItem(value: 'CV', child: Text('CV')),
                    DropdownMenuItem(
                        value: 'Amperometry', child: Text('Amperometry'))
                  ]),
            ...inputs,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, 
              children: [
                Expanded(
                    flex: 5,
                    child: RaisedButton(
                        onPressed: () {
                          if (_loadVariables()) {
                            Experiment currentExperiment =
                                new Experiment(experimentSettings);
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) => AnalysisScreen(
                                      experiment: currentExperiment,
                                    )));
                          }
                        },
                        child: Text('Run Test')
                    )
                  ),
                Spacer(flex: 1),
                Expanded(
                    flex: 5,
                    child: RaisedButton(
                        onPressed: () async {
                          // if inputs valid
                          if (_loadVariables()) {
                            if (file == null) {
                              _saveNewFile();
                            } else {
                              if (await experimentSettings.overwriteFile(file)) {
                                Scaffold.of(context).showSnackBar(
                                    SnackBar(content: Text('File Updated')));
                              } else {
                                Scaffold.of(context).showSnackBar(SnackBar(
                                    content: Text('Error updating file')));
                              }
                            }
                          }
                        },
                        child: Text('Save')))
            ]),
            if (file != null)
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Expanded(
                    flex: 5,
                    child: RaisedButton(
                        onPressed: () => Share.shareFiles([file.path]),
                        child: Text('Export'))),
                Spacer(flex: 1),
                Expanded(
                    flex: 5,
                    child: RaisedButton(
                        onPressed: _saveNewFile,
                        child: Text('Save as New Config')))
              ])
          ]),
        )));
  }
}

/*
  Validates on formKey.currentState.validate()
  Calls callback with double of input on formKey.currentState.save()
*/
class ValueInput extends StatelessWidget {
  ValueInput(this.text, this.callback, this.value, this.validator);

  final String text,
      value; // Text is displayed name, units is the displayed unit val at end
  final Function callback, validator; // Callback called on save

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        decoration: InputDecoration(labelText: text),
        keyboardType: TextInputType.number,
        initialValue: value,
        validator: (String value) {
          if (value.isEmpty) {
            return 'Please Enter a Value';
          } else {
            try {
              if (this.validator != null){
                return this.validator(value);
              } else {
                double.parse(value);
                return null;
              }
            } catch (e) {
              return 'Enter a valid number';
            }
          }
        },
        onSaved: (String val) {
          callback(double.parse(val));
        });
  }
}

class DropDownInput extends StatefulWidget {
  final List<String> labelStrings;
  final List values;
  final String hint;
  final initialVal;
  final Function callback;

  const DropDownInput(
      {Key key,
      this.labelStrings,
      this.values,
      this.hint = '',
      this.initialVal,
      this.callback})
      : super(key: key);

  @override
  _DropDownInputState createState() => _DropDownInputState();
}

class _DropDownInputState extends State<DropDownInput> {
  var selectedInput;

  @override
  void initState() {
    super.initState();
    selectedInput = widget.initialVal;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      hint: Text(widget.hint),
      value: selectedInput,
      onChanged: (value) {
        setState(() {
          selectedInput = value;
        });
      },
      items: List.generate(
          widget.labelStrings.length,
          (i) => DropdownMenuItem(
              value: widget.values[i], child: Text(widget.labelStrings[i]))),
      validator: (val) => val == null ? 'Please select a value' : null,
      onSaved: (val) {
        widget.callback(val);
      },
    );
  }
}
