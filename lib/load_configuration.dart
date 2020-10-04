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
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.blue,
          textTheme: ButtonTextTheme.primary
        )
      ),
      home: LoadConfig()
    );
  }
}

class LoadConfig extends StatelessWidget {
  Widget build(BuildContext context){
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Load Configuration'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: (){
              Navigator.pop(context);
            },
          ),
          bottom: TabBar(
            tabs: [
              Tab(child: Text('CV')),
              Tab(child: Text('Amperometry'))
            ]
          ),
        ),
        body: TabBarView(
          children: [
            LoadConfigType(expType: 'CV'),
            LoadConfigType(expType: 'Amperometry')
          ],
        ),
      )
    );
  }
}

class LoadConfigType extends StatefulWidget {
  final String expType;
  const LoadConfigType({Key key, this.expType}) : super(key: key);
  @override
  _LoadConfigState createState() => _LoadConfigState();
}

class _LoadConfigState extends State<LoadConfigType> {

  Future<List<File>> files;

  @override
  void initState() {
    super.initState();
    files = _loadConfigs();
  }
  
  Future<List<File>> _loadConfigs() async {    
    // Load config directory
    Directory appDir = await getApplicationDocumentsDirectory();
    Directory configDir = Directory(appDir.path + '/' +  (widget.expType == 'CV' ? 'cv_experiments': 'amp_experiments') + '/');
    List<File> returnFiles = [];
    if (await configDir.exists()){
      List<FileSystemEntity> items = configDir.listSync(recursive: false);
      for (FileSystemEntity f in items){
        if (f is File){
          returnFiles.add(f);
        }
      }
    }
    
    return returnFiles;
  }

  // Delete a file
  // TODO: Make efficient?
  Future<bool> _deleteFile(File f) async {
    try {
      await f.delete();
      setState((){
        files = _loadConfigs();
      });
      return true;
    } catch(e) {
      return false;
    }
  }

  Future<void> passData(File f, BuildContext context) async{
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AdvancedSetup(f, widget.expType),
      )
    );
    setState(() {
      files = _loadConfigs();
    });
  }

  @override 
  Widget build(BuildContext context){
    return FutureBuilder<List<File>>(
      future: files,
      builder: (BuildContext context, AsyncSnapshot<List<File>> snapshot){
        if (snapshot.hasData){
          return ListView.separated(
            itemBuilder: (BuildContext context, int i){
              File f = snapshot.data[i];
              String fileName = f.path.split('/').last.split('.').first;
              return Dismissible(
                key: UniqueKey(),
                direction: DismissDirection.endToStart,
                child: ListTile(
                  onTap: () async{
                      await passData(f, context);
                  },
                  title: Text(fileName)
                ),
                background: Container(
                  color: Colors.red,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Icon(
                      Icons.delete,
                      color: Colors.black
                    )
                  )
                ),
                onDismissed: (DismissDirection direction) {
                  setState((){
                    _deleteFile(f);
                  });
                  Scaffold.of(context).showSnackBar(SnackBar(content: Text('Deleted ' + fileName)));
                },
                confirmDismiss: (DismissDirection direction) async {
                  return showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Are you sure you want to delete '+ fileName + '?'),
                        actions: [
                          MaterialButton(
                            child: Text('Delete'),
                            onPressed: (){
                              Navigator.of(context).pop(true);
                            },
                          ),
                          MaterialButton(
                            child: Text('Cancel'),
                            onPressed: (){
                              Navigator.of(context).pop(false);
                            },)
                        ],
                      );
                    });
                },
              );
            }, 
            separatorBuilder: (BuildContext context, int index)=> Divider(), 
            itemCount: snapshot.data.length);
          
        } 
        return ListView(
          children: []);
      }
    );
  }
}
