import 'package:flutter/material.dart';

class ExploreScreen extends StatefulWidget {
  @override
  _ExploreScreenState createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  @override
  Widget build(BuildContext context) {
   return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        brightness: Brightness.dark,
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(
            color: Colors.white, //change your color here
          ),
        elevation: .2,
         title: Text('Explore',
         style: TextStyle(
           color: Colors.white,
           fontFamily: "Avenir",
          fontWeight: FontWeight.w900,
         ),
        ),
        
      ),
    );
  }
}