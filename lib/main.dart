import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:sweep_stat_app/bluetooth_management.dart';
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
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
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
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /*FractionallySizedBox(
              widthFactor: 0.5,
              child:*/
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  PrimaryMenuButton("GUIDED SETUP", Key("guided-setup"),
                      MaterialPageRoute(builder: (context) => GuidedSetup())),
                  PrimaryMenuButton("ADVANCED SETUP", Key('advanced-setup'),
                      MaterialPageRoute(builder: (context) => AdvancedSetup())),
                ],
              ),
            ),
            //),
            /*SizedBox(
              height: 50,
            ),*/
            /*FractionallySizedBox(
              widthFactor: 0.6,
              child: */
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SecondaryMenuButton("RECENT RESULTS", Key('recent-results'),
                      MaterialPageRoute(builder: (context) => RecentResults())),
                  SecondaryMenuButton("LOAD CONFIG", Key('load-config'),
                      MaterialPageRoute(builder: (context) => LoadConfig())),
                ],
              ),
            ),
            //)
          ],
        ));
  }
}
