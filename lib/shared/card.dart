import 'package:flutter/material.dart';

class Card extends StatefulWidget {
  @override
  _CardState createState() => _CardState();
}

class _CardState extends State<Card> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      height: 300,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          //Put the images from the listview
          image: DecorationImage(
            image: NetworkImage(''),
            fit: BoxFit.cover
          )
        ),
      child: new Text(
        'Title',
        style: new TextStyle(
          fontFamily: "Avenir",
          fontWeight: FontWeight.bold,
          fontSize: 40,
        ),
      ),
    );
  }
}