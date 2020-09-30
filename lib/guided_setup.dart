import 'package:flutter/material.dart';
import 'guided_setup_pages/gs_page1.dart';
import 'guided_setup_pages/gs_page2.dart';
import 'guided_setup_pages/gs_page3.dart';
import 'guided_setup_pages/gs_page4.dart';
import 'guided_setup_pages/gs_page5.dart';
import 'guided_setup_pages/gs_page6.dart';
import 'guided_setup_pages/gs_page7.dart';

// NOTE: I'm using the main function and the MyApp class for testing until we have a main page implemented
void main() {
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
}

class GuidedSetup extends StatefulWidget {
  const GuidedSetup({Key key}) : super(key: key);
  @override
  _GuidedSetupState createState() => _GuidedSetupState();
}

class _GuidedSetupState extends State<GuidedSetup> {
  int _currentPage = 0;
  String selected =
      ">25"; // Temporary variable for holding selected value of page 3 until we implement the Voltammetry Settings
  List<Widget> _pages;

  void _onBottomNavTapped(int index) {
    if (index == 0 && _currentPage > 0) {
      setState(() {
        _currentPage -= 1;
      });
    } else if (index == 1 && _currentPage < 7) {
      setState(() {
        _currentPage += 1;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _pages = [
      GSPage1(),
      GSPage2(),
      GSPage3(
          selected: selected,
          callback: (String val) {
            setState(() {
              selected = val;
            });
          }),
      GSPage4(),
      GSPage5(),
      GSPage6(),
      GSPage7(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Guided Setup - Step ' +
              (_currentPage + 1).toString() +
              " of 10")),
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
