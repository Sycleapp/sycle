import 'package:flutter/material.dart';
import 'dart:math';

class Respond extends StatefulWidget {
  @override
  _RespondState createState() => _RespondState();
}

class _RespondState extends State<Respond> {
  List colors = [Colors.red, Colors.orange, Colors.yellow, Colors.green, Colors.blue, Colors.purple];
  Random rand = new Random();
  int index = 0;
  
  //give random background color every time page is rendered when discover card clicked on
  void initState(){
    setState(() => index = rand.nextInt(6));
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors[index],
      body: SizedBox.expand(
        child: GestureDetector(
          onTap: (){
            Navigator.of(context).pop();
          },
          child: Container(
            padding: EdgeInsets.all(15.0),
            child: Text("Name", style: TextStyle(color: Colors.white))
          )
        )
      )
    );      
  }
}
