import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class FileTabPage extends StatelessWidget {
  final String title, dir1, dir2, name1, name2;
  final Function onClick;

  FileTabPage({this.title, this.dir1, this.dir2, this.name1, this.name2, this.onClick});

  Widget build(BuildContext context){
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(title),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: (){
              Navigator.pop(context);
            },
          ),
          bottom: TabBar(
            tabs: [
              Tab(child: Text(name1)),
              Tab(child: Text(name2))
            ]
          ),
        ),
        body: TabBarView(
          children: [
            LoadConfigType(directory: dir1, name: name1, onClick: onClick),
            LoadConfigType(directory: dir2, name: name2, onClick: onClick)
          ],
        ),
      )
    );
  }
}

class LoadConfigType extends StatefulWidget {
  final String directory, name;
  final Function onClick;
  const LoadConfigType({Key key, this.directory, this.name, this.onClick}) : super(key: key);
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
    Directory configDir = Directory(appDir.path + '/' +  (widget.directory) + '/');
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
      setState(() {
        files = _loadConfigs();
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> passData(File f, BuildContext context) async{
    await widget.onClick(f, widget.name);
    setState(() {
      files = _loadConfigs();
    });
  }

  @override
  Widget build(BuildContext context) {
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
