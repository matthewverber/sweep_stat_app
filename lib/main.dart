import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:sweep_stat_app/bluetooth_mangement.dart';
import 'guided_setup.dart';
import 'advanced_setup.dart';
import 'load_configuration.dart';
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

  Widget _buildPrimaryButton(String buttonText, Widget route) {
    return Container(
        margin: EdgeInsets.all(10),
        child: SizedBox(
            width: 200,
            height: 50,
            child: FlatButton(
              color: Colors.blue,
              textColor: Colors.white,
              disabledColor: Colors.grey,
              disabledTextColor: Colors.black,
              padding: EdgeInsets.all(5.0),
              splashColor: Colors.blueAccent,
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => route));
              },
              child: Text(
                buttonText,
                style: TextStyle(fontFamily: 'Roboto', fontSize: 12.0, fontWeight: FontWeight.w500),
              ),
            )));
  }

  Widget _buildSecondaryButton(String buttonText, Widget route) {
    return OutlineButton(
      color: Colors.grey,
      textColor: Colors.blue,
      disabledBorderColor: Colors.grey,
      disabledTextColor: Colors.grey,
      padding: EdgeInsets.all(8.0),
      splashColor: Colors.blueAccent,
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => route));
      },
      child: Text(
        buttonText,
        style: TextStyle(fontSize: 20.0),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
        ),
        body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 3,
                child: Column(),
              ),
              Expanded(
                flex: 4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildPrimaryButton("GUIDED SETUP", GuidedSetup()),
                    _buildPrimaryButton("ADVANCED SETUP", AdvancedSetup()),
                  ],
                ),
              ),
              Expanded(flex: 3, child: Column()),
            ],
          ),
          SizedBox(
            height: 100,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                flex: 2,
                child: Column(),
              ),
              Expanded(
                flex: 6,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildSecondaryButton("RECENT RESULTS", RecentResults()), // TODO: Needs recent results widget route
                    _buildSecondaryButton("LOAD CONFIG", LoadConfig()),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Column(),
              ),
            ],
          )
        ])
      /* Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FlatButton(
              color: Colors.blue,
              textColor: Colors.white,
              disabledColor: Colors.grey,
              disabledTextColor: Colors.black,
              padding: EdgeInsets.all(8.0),
              splashColor: Colors.blueAccent,
              onPressed: () {
                /* ... */
              },
              child: Text(
                "GUIDED SETUP",
                style: TextStyle(fontSize: 20.0),
              ),
            ),
            FlatButton(
              color: Colors.blue,
              textColor: Colors.white,
              disabledColor: Colors.grey,
              disabledTextColor: Colors.black,
              padding: EdgeInsets.all(8.0),
              splashColor: Colors.blueAccent,
              onPressed: () {
                _menuButtonPress(AdvancedSetup());
              },
              child: Text(
                "ADVANCED SETUP",
                style: TextStyle(fontSize: 20.0),
              ),
            ),
            OutlineButton(
              color: Colors.grey,
              textColor: Colors.blue,
              disabledBorderColor: Colors.grey,
              disabledTextColor: Colors.grey,
              padding: EdgeInsets.all(8.0),
              splashColor: Colors.blueAccent,
              onPressed: () {
                /*...*/
              },
              child: Text(
                "RECENT RESULTS",
                style: TextStyle(fontSize: 20.0),
              ),
            ),
            OutlineButton(
              color: Colors.grey,
              textColor: Colors.blue,
              disabledBorderColor: Colors.grey,
              disabledTextColor: Colors.grey,
              padding: EdgeInsets.all(8.0),
              splashColor: Colors.blueAccent,
              onPressed: () {
                _menuButtonPress(LoadConfigWrapper());
              },
              child: Text(
                "LOAD CONFIG",
                style: TextStyle(fontSize: 20.0),
              ),
            ),
            OutlineButton(
              color: Colors.grey,
              textColor: Colors.blue,
              disabledBorderColor: Colors.grey,
              disabledTextColor: Colors.grey,
              padding: EdgeInsets.all(8.0),
              splashColor: Colors.blueAccent,
              onPressed: () {
                /* ... */
              },
              child: Text(
                "BLUETOOTH CONNECTION",
                style: TextStyle(fontSize: 20.0),
              ),
            ),
          ],
        ),
      ), */
      /*floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),*/ // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
