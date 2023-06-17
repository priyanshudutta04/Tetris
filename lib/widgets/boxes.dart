import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Boxes extends StatelessWidget {

  Boxes({super.key, required this.color, });
    var color;
    

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(0.5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: color
      ),
     
    );
  }
}