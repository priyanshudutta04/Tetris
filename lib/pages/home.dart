// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, sort_child_properties_last

import 'dart:async';
import 'package:hive/hive.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:tetris/widgets/boxes.dart';
import 'package:tetris/widgets/drawer.dart';
import 'dart:math';

import '../utils/db.dart';
import '../widgets/piece.dart';

//2 * 2 list
List<List<Tetromino?>> gameBoard = List.generate(
  col,
  (i) => List.generate(
    row,
    (i) => null
  )
);


class HomePage extends StatefulWidget {
   HomePage({super.key,});
  @override
  State<HomePage> createState() => _HomePageState();
  
}

class _HomePageState extends State<HomePage> {

  double value=0;
  int row=10;
  int col=15;
  int score=0;

  int highscore=-1;

  Piece currentPiece=Piece(type: Tetromino.TTT);

  bool over=false;

  //reference the hive box
  final highbox = Hive.box("HighScore_db");
  HighScoreDB db = HighScoreDB();

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
    
    super.initState();
    //start game when app starts
    startGame();
  }

  @override
  void dispose() {
    
    // TODO: implement dispose
    super.dispose();
  }

  void startGame(){
    currentPiece.genPieces();

    Duration frameRate=const Duration(milliseconds: 500);
    gameLoop(frameRate);
  }

  void gameLoop(Duration frameRate){
    Timer.periodic(
      frameRate,
      (timer){
        setState(() {
          checkLanding();
          if(gameOver()==true){
            timer.cancel();
            showGameOver();
          }
          currentPiece.pieceMove(Directions.down);
        });
      }
    );
  }

  void showGameOver(){
    showDialog(context: this.context, builder: (context) => AlertDialog(
      backgroundColor: const Color.fromARGB(255, 51, 49, 44),
      content: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 51, 49, 44),
          borderRadius: BorderRadius.circular(10)
        ),
        
        child:Text("Game Over",style: TextStyle(color: Colors.white,fontSize: 24),),
      ),
      
      actions: [
        TextButton(onPressed: (){
            Navigator.pop(context);
            resetGame();
          }, 
          child: Text("Play Again")
        )
      ],
    ));
  }

  bool collisionDet(Directions direction){
     
    for(int i=0;i<currentPiece.positions.length;i++){
      int currow =(currentPiece.positions[i]/row).floor();
      int curcol =currentPiece.positions[i]%row;

      if(direction==Directions.left){
        curcol-=1;
      }
      else if(direction==Directions.right){
        curcol+=1;
      }
      else if(direction==Directions.down){
        currow+=1;
      }

      if( currow>13 || curcol<0|| curcol>= row){
        return true;

      }
      if(currow>=0 && curcol>=0){
          if(gameBoard[currow][curcol]!=null){
            return true;
          }
      }

    }
     return false;  
  }

  void checkLanding(){
    if(collisionDet(Directions.down)){
     
       for(int i=0;i<currentPiece.positions.length;i++){
        int currow =(currentPiece.positions[i]/row).floor();
        int curcol =currentPiece.positions[i]%row;
        if(currow>=0 && curcol>=0){
          gameBoard[currow][curcol]=currentPiece.type;
        }
      }
      score+=4;
      newPiece();
    }
  }

  void newPiece(){   
    Random rand=Random();
    Tetromino randoType=Tetromino.values[rand.nextInt(Tetromino.values.length)];
    currentPiece=Piece(type: randoType);
    currentPiece.genPieces();
    if(gameOver()==true){
      over=true;
    }
  }

  void moveLeft(){
    if(!collisionDet(Directions.left)){
      setState(() {
        currentPiece.pieceMove(Directions.left);
      });
    }
  }
  void resetGame(){
    setState(() {
      if(score>highscore){
        highscore=score;
        db.score=score;
      }
    });
     db.updateData();
    gameBoard=List.generate(
      col,
      (i) => List.generate(
        row,
        (i) => null
      )
    );
    over=false;
    score=0;
    newPiece();
    startGame();
  }
  void moveRight(){
     if(!collisionDet(Directions.right)){
      setState(() {
        currentPiece.pieceMove(Directions.right);
      });
    }
  }

  bool gameOver(){
    for(int i=0;i<row;i++){
      if(gameBoard[0][i]!=null){
        return true;
      }
    }
    return false;
  }


  @override
  Widget build(BuildContext context) {


    return Scaffold(
         
      // Using Stack for two fold animation. dont Add Expand
      body: Stack(
        children: [
          DrawerPage(
            high: highscore,
          ),

          //Menu Animation
          TweenAnimationBuilder(
            tween: Tween<double>(begin: 0,end: value),
            duration: Duration(milliseconds: 500),
            curve: Curves.easeIn,
            builder: (_,double val,__){
              return(
                Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..setEntry(0, 3, 200*val)
                  ..rotateY(pi/6 * val),

                  //home page begins
                  child:GestureDetector(
                    onTap: (){
                      setState(() {
                        value==1?value=0:value=0;
                      });
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Scaffold(
                        backgroundColor: Color.fromRGBO(27, 18, 18, 1),  
                          body: SafeArea(  
                            child: Column(
                              children: [
                                
                                Padding(
                                  padding: const EdgeInsets.only(left: 20,right: 20,top: 25),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      GestureDetector(
                                        onTap: (){
                                          setState(() {
                                            value==0?value=1:value=0;
                                          });
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            color: Colors.grey[400]
                                          ),
                                          child: Image.asset(
                                              "assets/images/menu.png",
                                              height: 20,
                                              width: 20,
                                            )
                                        ),
                                      ),

                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children:  [      
                                          Text(
                                            "T",
                                            style: TextStyle(
                                              color: Colors.cyan,
                                              fontSize: 32,
                                              fontWeight: FontWeight.bold
                                            ),
                                          ),
                                          Text(
                                            "e",
                                            style: TextStyle(
                                              color: Color.fromARGB(255, 22, 223, 29),
                                              fontSize: 32,
                                              fontWeight: FontWeight.bold
                                            ),
                                          ),
                                          Text(
                                            "t",
                                            style: TextStyle(
                                              color: Colors.red,
                                              fontSize: 32,
                                              fontWeight: FontWeight.bold
                                            ),
                                          ),
                                          Text(
                                            "r",
                                            style: TextStyle(
                                              color: Colors.orange,
                                              fontSize: 32,
                                              fontWeight: FontWeight.bold
                                            ),
                                          ),
                                          Text(
                                            "i",
                                            style: TextStyle(
                                              color: Colors.deepPurpleAccent,
                                              fontSize: 32,
                                              fontWeight: FontWeight.bold
                                            ),
                                          ),
                                          Text(
                                            "x",
                                            style: TextStyle(
                                              color: Color.fromARGB(255, 248, 93, 144),
                                              fontSize: 32,
                                              fontWeight: FontWeight.bold
                                            ),
                                          ),
                                        ]   
                                      ),

                                    ],
                                  ),
                                ),
                              
                                SizedBox(height: 25,),

                                Expanded(
                                  child: GridView.builder(
                                    itemCount: row*col,
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: row,
                                    ), 
                                    itemBuilder: (context, index) {
                                
                                      int currow =(index /row).floor();
                                      int curcol =index % row;
                                      
                                      if(currentPiece.positions.contains(index)){
                                        return Boxes(
                                          color: currentPiece.color,
                                          
                                        );
                                      }
                                
                                      else if(gameBoard[currow][curcol]!=null){
                                        final Tetromino? tetType=gameBoard[currow][curcol];
                                        return Boxes(
                                          color: tetColors[tetType],
                                          
                                        );
                                      }
                                
                                      else{
                                        return Boxes(
                                          color: const Color.fromARGB(255, 46, 37, 37),
                                          
                                        );
                                      }
                                      
                                    }
                                  ),
                                ),
                                


                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                                  child: Row(

                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      IconButton(
                                        onPressed: moveLeft, 
                                        icon: Icon(Icons.arrow_back_rounded,size: 30,),
                                        color: Colors.white,
                                        
                                      ),
                                      IconButton(
                                        onPressed: resetGame, 
                                        icon: Icon(Icons.replay_outlined,size: 30,),
                                        color: Colors.white,
                                        
                                      ),
                                      IconButton(
                                        onPressed: moveRight, 
                                        icon: Icon(Icons.arrow_forward_rounded,size: 30,),
                                        color: Colors.white,
                                        
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 20),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                                    
                                    decoration: BoxDecoration(
                                      color: const Color.fromARGB(255, 34, 32, 31),
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: Colors.red,
                                        width: 2
                                      )
                                    ),
                                    child: Text(
                                      "Score : $score",
                                      style: TextStyle(color: Colors.white,fontSize: 22),
                                      ),
                                  ),
                                ),  
                                                           
                              ],
                            ),
                          )
                        
                      ),
                    ),
                  ),
                )
              );
            },

          ),
        ],
         
      ),
    );
  }
}