import 'dart:io';
import 'package:flutter/material.dart';
import 'file_tab_page.dart';
import 'advanced_setup.dart';

// Widget responsible for selecting which config file a user wants to be loaded from the existing files
class LoadConfig extends StatelessWidget {
  Widget build(BuildContext context){
    return FileTabPage(title: "Load Configuration", dir1: "cv_configs", dir2: "amp_configs", name1: "CV", name2: "Amperometry",
      onClick: (File f, String expType){
        return Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AdvancedSetup(f, expType),
        )
      );
    }
    );
  }
}
