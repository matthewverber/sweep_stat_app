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
            title: 'Load Configuration', home: LoadConfigWrapper()));
  }
}

// TODO: What is flutter convention for this?
class LoadConfigWrapper extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Load Configuration')), body: LoadConfig());
  }
}

class LoadConfig extends StatefulWidget {
  const LoadConfig({Key key}) : super(key: key);
  @override
  _LoadConfigState createState() => _LoadConfigState();
}

class _LoadConfigState extends State<LoadConfig> {
  Future<List<File>> files;
  bool isDeleting = false;

  initState() {
    super.initState();
    files = _loadConfigs();
  }

  Future<List<File>> _loadConfigs() async {
    // Load config directory
    Directory appDir = await getApplicationDocumentsDirectory();
    Directory configDir = Directory(appDir.path + '/experiment_settings/');

    // Return empty list if configDir doesn't exist
    if (!await configDir.exists()) {
      return [];
    }

    // Get the list of files within the directory and add to fileNames
    List<File> returnFiles = [];
    List<FileSystemEntity> items = configDir.listSync(recursive: false);
    for (FileSystemEntity f in items) {
      if (f is File) {
        returnFiles.add(f);
      }
    }
    return returnFiles;
  }

  // Delete a file
  // TODO: Make efficient?
  Future<bool> _deleteFile(File f) async {
    try {
      await f.delete();
      setState(() {
        files = _loadConfigs();
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  void passData(File f, BuildContext context) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AdvancedSetup(f),
        ));
    setState(() {
      files = _loadConfigs();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<File>>(
        future: files,
        builder: (BuildContext context, AsyncSnapshot<List<File>> snapshot) {
          List<RaisedButton> children = [];
          if (snapshot.hasData) {
            snapshot.data.forEach((File f) {
              children.add(RaisedButton(
                  onPressed: () async {
                    if (!isDeleting) {
                      passData(f, context);
                    } else {
                      String result = await _deleteFile(f)
                          ? "File deleted"
                          : "File could not be deleted";
                      Scaffold.of(context)
                          .showSnackBar(SnackBar(content: Text(result)));
                    }
                  },
                  child: Text(f.path.split('/').last.split('.').first)));
            });
          }
          return ListView(
            children: [
              Row(
                children: [
                  Text('Delete'),
                  Switch(
                      value: isDeleting,
                      onChanged: (bool val) {
                        setState(() {
                          isDeleting = val;
                        });
                      })
                ],
              ),
              ...children
            ],
          );
        });
  }
}
