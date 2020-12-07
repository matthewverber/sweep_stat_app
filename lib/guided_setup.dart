import 'package:flutter/material.dart';
import 'package:sweep_stat_app/experiment.dart';
import 'package:sweep_stat_app/experiment_settings.dart';
import 'package:sweep_stat_app/analysis.dart';
import 'guided_setup_pages/gs_page1.dart';
import 'guided_setup_pages/gs_page2.dart';
import 'guided_setup_pages/gs_page3.dart';
import 'guided_setup_pages/gs_page4.dart';
import 'guided_setup_pages/gs_page5.dart';
import 'guided_setup_pages/gs_page6.dart';
import 'guided_setup_pages/gs_page7.dart';
import 'guided_setup_pages/gs_page8.dart';
import 'guided_setup_pages/gs_page9.dart';
import 'guided_setup_pages/gs_page10.dart';
import 'guided_setup_pages/gs_pageFinish.dart';

// NOTE: I'm using the main function and the MyApp class for testing until we have a main page implemented
/*void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'SweepStat',
        theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            textTheme: TextTheme(
                bodyText1: TextStyle(fontSize: 17.0, height: 1.3),
                bodyText2: TextStyle(fontSize: 14.0, height: 1.25))),
        home: GuidedSetup());
  }
}*/

class GuidedSetup extends StatefulWidget {
  const GuidedSetup({Key key}) : super(key: key);
  @override
  _GuidedSetupState createState() => _GuidedSetupState();
}

class _GuidedSetupState extends State<GuidedSetup> {
  int _currentPage = 0;
  String _title;

  GainSettings _selectedGain = GainSettings.nA10;
  Electrode _selectedElectrode = Electrode.pseudoref;
  VoltammetrySettings voltammetrySettings = new VoltammetrySettings();
  double _initialPot = 0.0;
  double _vertexPot = 0.0;
  double _scanRate = 0.0;
  List<Widget> _pages;

  void _onBottomNavTapped(int index) {
    print(_currentPage);
    print(_title);
    if (index == 0 && _currentPage > 0) {
      setState(() {
        _currentPage -= 1;
        _title = 'Guided Setup - Step ${(_currentPage + 1).toString()} of 10';
      });
    } else if (index == 1 && _currentPage < 10) {
      setState(() {
        _currentPage += 1;
        if (_currentPage == 10)
          _title = "Guided Setup - Complete";
        else
          _title = 'Guided Setup - Step ${(_currentPage + 1).toString()} of 10';
      });
    } else if (index == 1 && _currentPage == 10) {
      voltammetrySettings.initialVoltage = _initialPot;
      voltammetrySettings.vertexVoltage = _vertexPot;
      voltammetrySettings.finalVoltage = _initialPot;
      voltammetrySettings.scanRate = _scanRate;
      voltammetrySettings.sweepSegments =
          2; // TODO: Taken from previous Java app. Is this the correct default value?
      voltammetrySettings.sampleInterval = 0.001; // Same question as above
      voltammetrySettings.gainSetting = _selectedGain;
      voltammetrySettings.electrode = _selectedElectrode;
      Experiment experiment = new Experiment(voltammetrySettings);
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => AnalysisScreen(
                experiment: experiment,
              )));
    }
  }

  @override
  void initState() {
    super.initState();
    _title = 'Guided Setup - Step ${(_currentPage + 1).toString()} of 10';
    _pages = [
      GSPage1(),
      GSPage2(),
      GSPage3(
          selected: _selectedGain,
          callback: (GainSettings val) {
            setState(() {
              _selectedGain = val;
            });
          }),
      GSPage4(),
      GSPage5(),
      GSPage6(),
      GSPage7(
          selected: _selectedElectrode,
          callback: (Electrode val) {
            setState(() {
              _selectedElectrode = val;
            });
          }),
      GSPage8(),
      GSPage9(
          initialPot: _initialPot,
          vertexPot: _vertexPot,
          callbackInitPot: (double initPot) {
            setState(() {
              _initialPot = initPot;
            });
          },
          callbackVertPot: (double vertPot) {
            setState(() {
              _vertexPot = vertPot;
            });
          }),
      GSPage10(
          scanRate: _scanRate,
          callback: (double val) {
            setState(() {
              _scanRate = val;
            });
          }),
      GSPageFinish(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
      ),
      body: Center(
          child: FractionallySizedBox(
              widthFactor: 0.9, child: _pages[_currentPage])),
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.chevron_left),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chevron_right),
            label: "",
          )
        ],
        onTap: _onBottomNavTapped,
        iconSize: 42.0,
      ),
    );
  }
}
