import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:sweep_stat_app/menu_buttons.dart';
import 'advanced_setup.dart';
import 'guided_setup.dart';
import 'load_configuration.dart';
import 'menu_buttons.dart';
import 'recent_results.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SweepStat',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'SweepStat'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  BluetoothDevice _bluetoothDevice;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(vertical: 75.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                    child: Container(
                  width: 200,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      PrimaryMenuButton(
                          "GUIDED SETUP", Key("guided-setup"), GuidedSetup()),
                      PrimaryMenuButton("ADVANCED SETUP", Key('advanced-setup'),
                          AdvancedSetup()),
                    ],
                  ),
                )),
                Expanded(
                    child: Container(
                  width: 300,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SecondaryMenuButton("RECENT RESULTS",
                          Key('recent-results'), RecentResults()),
                      SecondaryMenuButton(
                          "LOAD CONFIG", Key('load-config'), LoadConfig()),
                    ],
                  ),
                )),
              ]),
        ));
  }
}
