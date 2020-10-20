import 'dart:io';
import 'package:flutter/material.dart';
import 'file_tab_page.dart';
import 'experiment.dart';
import 'analysis.dart';

class RecentResults extends StatelessWidget {
  Widget build(BuildContext context){
    return FileTabPage(title: "Recent Results", dir1: "cv_experiments", dir2: "amp_experiments", name1: "CV", name2: "Amperometry",
      onClick: (File f, String expType) async{
        // TODO: Implement loading experiment from file
        Experiment e =  await Experiment.loadFromFile(f, expType);
        return Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AnalysisScreen(experiment: e),
        )
      );
    }
    );
  }
}

