import 'package:flutter/material.dart';
import 'package:sweep_stat_app/advanced_setup.dart';
import 'package:sweep_stat_app/analysis.dart';
import 'package:sweep_stat_app/experiment.dart';

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
      home: AdvancedSetup(),
    );
  }
}

//class MyHomePage extends StatefulWidget {
//  MyHomePage({Key key, this.title}) : super(key: key);
//
//  final String title;
//
//  @override
//  _MyHomePageState createState() => _MyHomePageState();
//}
//
//class _MyHomePageState extends State<MyHomePage> {
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      body: SafeArea(
//        child: RaisedButton(
//          onPressed: () async {
//          Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => {AdvancedSetup()}));
//            //            ExperimentSettings testValues = ExperimentSettings(
////              initialVoltage: 0.0,
////              highVoltage: 5.0,
////              lowVoltage: 0.0,
////              finalVoltage: 5.0,
////              scanRate: .05,
////              sweepSegments: .05,
////              sampleInterval: 5.0,
////              isAutoSens: false,
////              isFinalE: false,
////              isAuxRecording: false,
////              projectName: "OmegaTest",
////              projectDescription: "None"
////            );
////            // TODO: Move to tests
////            Navigator.push(
////                context,
////                MaterialPageRoute(
////                    builder: (BuildContext context) =>
////                        AnalysisScreen(experiment: Experiment(testValues))));
//          },
//        ),
//      ),
//    );
//  }
//}
