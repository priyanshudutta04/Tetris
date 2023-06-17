// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../utils/routes.dart';

class DrawerPage extends StatefulWidget {
  const DrawerPage({super.key});

  @override
  State<DrawerPage> createState() => _DrawerPageState();
}

class _DrawerPageState extends State<DrawerPage> {
  void homenav(){
    Future.delayed(const Duration(seconds: 1));
    Navigator.pushNamed(context, Myroutes.homeRoute);
    }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: SafeArea(
        child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(144, 202, 249, 1),
                  Color.fromRGBO(159, 168, 218, 1)
                ]
              )
            ),
            
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 10),
                child: Column(
                  children: [
                    ListTile(
                    leading: GestureDetector(
                      onTap: homenav,
                      child: CircleAvatar(
                        backgroundColor: Colors.white24,
                        child: Icon(
                          Icons.person,
                          color: Colors.white,
                        ),
                        ),
                    ),
                    title: Text("User",style: TextStyle(color: Colors.white,fontSize: 18),),
                    ),
                  ],
                )
              )
            
          ),
      ),
    );
    
  }
}