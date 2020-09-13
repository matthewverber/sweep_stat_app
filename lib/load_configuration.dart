import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'advanced_setup.dart';

// Widget responsible for selecting which config file a user wants to be loaded from the existing files


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
        title: 'Load Configuration',
        home: Scaffold(
          appBar: AppBar(title: Text('Load Configuration')),
          body: LoadConfig()
        )
      )
    );
  }
}

class LoadConfig extends StatelessWidget {

  Future<List<File>> _loadConfigs() async {    
    // Load config directory
    Directory appDir = await getApplicationDocumentsDirectory();
    Directory configDir = Directory(appDir.path + '/experiment_settings/');

    // Return empty list if configDir doesn't exist
    if (!await configDir.exists()){
      return [];
    }

    // Get the list of files within the directory and add to fileNames
    List<File> files = [];
    List<FileSystemEntity> items = configDir.listSync(recursive: false);
    for (FileSystemEntity f in items){
      if (f is File){
        files.add(f);
      }
    }
    return files;
    // Load filenames from file objects
    /*
    configFiles.forEach((File f){
      fileNames.add(f.path);
    });*/
  }

  void passData(File f, BuildContext context){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AdvancedSetup(f),
      )
    );
  }

  @override 
  Widget build(BuildContext context){
    return FutureBuilder<List<File>>(
      future: _loadConfigs(),
      builder: (BuildContext context, AsyncSnapshot<List<File>> snapshot){
        List<RaisedButton> children = [];
        if (snapshot.hasData){
          snapshot.data.forEach((File f) {
            children.add(
              RaisedButton(
                onPressed: ()=>passData(f, context),
                child: Text(f.path.split('/').last.split('.').first))
            );
          });
        } 
        return ListView(
          children: children,);
      }
    );
  }
}

/*
snapshot.data.map((File f)=>{
            RaisedButton(
              child: Text(f.path),
              onPressed: ()=>passData(f),
            )
          }).toList();
          */