import 'package:flutter/material.dart';
import 'package:tetris/pages/home.dart';
import 'package:tetris/utils/routes.dart';
import 'package:tetris/widgets/drawer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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
        Myroutes.drawerRoute: (context) => DrawerPage(),
      },
    );
  }
}

