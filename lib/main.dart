import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tetris/pages/home.dart';
import 'package:tetris/utils/routes.dart';
import 'package:tetris/widgets/drawer.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async{
    //initalizing hive
  await Hive.initFlutter();
  var highbox = await Hive.openBox("HighScore_db");
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {


  @override
  void initState() {
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Color.fromRGBO(27, 18, 18, 1), // Background color of the navigation bar
      statusBarColor: Color.fromRGBO(27, 18, 18, 1), // Background color of the status bar
    ));
  }
  
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, //removes debug banner
      theme: ThemeData( 
        primarySwatch: Colors.blue,
      ),

      initialRoute: "/", //this route will open first

      routes: {
        //creating routes for different pages in app
        "/": (context) => HomePage(), //main root
        Myroutes.drawerRoute: (context) => DrawerPage(high: 0,),
      },
    );
  }
}

