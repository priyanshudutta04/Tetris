
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';

class HighScoreDB{

  int score=0;
  //reference the hive box
  final highbox = Hive.box("HighScore_db");
  
  void createInitialData(){
    score=0;
  }

  void loadData(){
    score=highbox.get("SCOREDB");
  }

  void updateData(){
    highbox.put("SCOREDB", score);
  }
}