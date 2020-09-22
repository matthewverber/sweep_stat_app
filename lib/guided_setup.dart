import 'package:flutter/material.dart';
import 'guided_setup_pages/gs_page1.dart';
import 'guided_setup_pages/gs_page2.dart';

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
          bodyText1: TextStyle(
            fontSize: 17.0,
            height: 1.3
          ),
          bodyText2: TextStyle(
            fontSize: 14.0,
            height: 1.25
          )
        )
      ),
      home: GuidedSetup()
    );
  }
}

class GuidedSetup extends StatefulWidget {
  const GuidedSetup({Key key}) : super(key: key);
  @override
  _GuidedSetupState createState() => _GuidedSetupState();
}

class _GuidedSetupState extends State<GuidedSetup> {
  int _currentPage = 1;

  void _onBottomNavTapped(int index){
    if (index == 0 && _currentPage > 1){
      setState(() {
        _currentPage -= 1;
      });
    } else if (index == 1 && _currentPage < 10){
      setState((){
        _currentPage += 1;
      });
    }

  }

  Widget _selectDisplayWidget() {
    switch(_currentPage){
      case 1: return GSPage1();
      case 2: return GSPage2();
      default:
        return Text("Page not implemented yet");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Guided Setup - Step ' + _currentPage.toString() + " of 10")),
      body: Center(
        child: FractionallySizedBox(
          widthFactor: 0.9,
          child: _selectDisplayWidget()
        )
      ),
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.chevron_left),
            title: Text("")
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chevron_right),
            title: Text("")
          )
        ],
        onTap: _onBottomNavTapped,
        iconSize: 42.0,
      ),
    );
  }
  
}