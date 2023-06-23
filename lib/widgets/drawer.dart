// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';

import '../utils/db.dart';
import '../utils/routes.dart';

class DrawerPage extends StatefulWidget {
  const DrawerPage({super.key});

  @override
  State<DrawerPage> createState() => _DrawerPageState();
}

class _DrawerPageState extends State<DrawerPage> {

  final highbox = Hive.box("HighScore_db");
  HighScoreDB db = HighScoreDB();

  int highscore=1;


  @override
  void initState() {
    if (highbox.get("SCOREDB") == null){
      db.createInitialData();
      highscore=db.score;
    }

    else {
      db.loadData();
      highscore = db.score;
    }
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body:Container(
            padding: EdgeInsets.symmetric(vertical: 40,horizontal: 5),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(43, 35, 39, 1),
                  Color.fromRGBO(74, 22, 38, 1)
                ]
              )
            ),
            
              child: Padding(
                padding: const EdgeInsets.all(0),
                child: Column(
                  children: [
                    ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.white24,
                        child: Icon(
                          Icons.person,
                          color: Colors.white,
                        ),
                        ),
                    
                    title: Text("User",style: TextStyle(color: Colors.white,fontSize: 18),),
                    ),
                    SizedBox(height: 20,),
                    ListTile(                     
                    leading: Icon(Icons.scoreboard,color: Colors.white,size: 24,),
                    title: Text("High Score: $highscore",style: TextStyle(color: Colors.white,fontSize: 18),),
                    ),
                    ListTile(   
                    leading: Icon(Icons.call,color: Colors.white,size: 24,),
                    title: Text("Contact Us",style: TextStyle(color: Colors.white,fontSize: 18),),
                    ),
                    ListTile(   
                    leading: Icon(Icons.star,color: Colors.white,size: 24,),
                    title: Text("Give a rating",style: TextStyle(color: Colors.white,fontSize: 18),),
                    ),
                  ],
                )
              )
            
          ),
      
    );
    
  }
}