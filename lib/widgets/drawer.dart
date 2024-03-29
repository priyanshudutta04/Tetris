// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utils/db.dart';
import '../utils/routes.dart';

class DrawerPage extends StatefulWidget {
  
  const DrawerPage({super.key, required this.high});

  final int high;
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


    void shoWSoon(){
    showDialog(context: this.context, builder: (context) => AlertDialog(
      backgroundColor: const Color.fromARGB(255, 51, 49, 44),
      
      content: Container(
        height: 90,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10)
        ),
        
        child:Center(child: Text("Comming Soon",style: TextStyle(color: Colors.white,fontSize: 20),)),
      ),
      
      
    ));
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
                    title: Text("High Score: ${widget.high}",style: TextStyle(color: Colors.white,fontSize: 18),),
                    ),
                    GestureDetector(
                      onTap: () async {
                        final url = Uri.parse(
                            'https://priyanshudutta.me');
                        launchUrl(url);
                      },
                      child: ListTile(   
                      leading: Icon(Icons.call,color: Colors.white,size: 24,),
                      title: Text("Contact Developer",style: TextStyle(color: Colors.white,fontSize: 18),),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        shoWSoon();
                      },
                      child: ListTile(   
                      leading: Icon(Icons.leaderboard,color: Colors.white,size: 24,),
                      title: Text("Leaderboard",style: TextStyle(color: Colors.white,fontSize: 18),),
                      ),
                    ),
                  ],
                )
              )
            
          ),
      
    );
    
  }
}