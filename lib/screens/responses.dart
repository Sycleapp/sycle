//This is the UI for the responces for a story
import 'package:Sycle/screens/screens.dart';
import 'package:Sycle/shared/scale_route.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';

class ResponseScreen extends StatefulWidget {
  @override
  _ResponseScreenState createState() => _ResponseScreenState();
}

class _ResponseScreenState extends State<ResponseScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        //Video playback
        color: Colors.black,
      child: Column(
        children: <Widget>[
          Container(
            //topBar
            color: Colors.black,
            height: 100,
            child: Expanded(child: Row(children: <Widget>[
              Container(
                margin: new EdgeInsets.all(1),
                width: 100,
                color: Colors.black,
                child: IconButton(
                  icon: Icon(Icons.close),
                  iconSize: 28,
                  color: Colors.white,
                  onPressed: () {
                    {
                  Navigator.pop(context);
                    }
                  },
                ),
                alignment: Alignment(-0.7, 0.5),
              ),
              Expanded(
                child: Container(
                  margin: new EdgeInsets.all(1),
                  color: Colors.black,
                  child: Text('Topic name',
                style: TextStyle(
                  fontFamily: 'Avenir',
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: Colors.white),
                ),
                alignment: Alignment(0, 0.35),
                  )),
              Container(
                margin: new EdgeInsets.all(1),
                width: 100,
                color: Colors.black,
                child: IconButton(
                  icon: Icon(Icons.add_circle_outline),
                  color: Colors.white,
                  iconSize: 28,
                  onPressed: () {
                    {
                  Navigator.pushNamed(context, '/camera');
                    }
                  },
                ),
                alignment: Alignment(.7, 0.5),
              )
            ],
            )
            )
          ),
          //User Responce info (Name and Location)
          Container(
            margin: new EdgeInsets.all(1),
            color: Colors.black,
            height: 30,
            child: Text('Name',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontFamily: 'Avenir',
              fontSize: 28
              )),
              alignment: Alignment(-.85, 0.5),
          ),
          Container(
            margin: new EdgeInsets.all(1),
            color: Colors.black,
            height: 40,
            child: Text('Location',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontFamily: 'Avenir',
              fontSize: 20
              )),
              alignment: Alignment(-.85, 0.5),
          ),
          //Safe Area
          Expanded(child: Column(children: <Widget>[
            Container(
              margin: new EdgeInsets.all(1),
              width: 414,
              color: Colors.black,
            )
          ],)),
          //Bottom UI
          Container(
            margin: new EdgeInsets.all(1),
            height: 90,
            color: Colors.black,
            child: Text('Caption',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 17
              ),
            ),
            alignment: Alignment(-.85, 0.5),
          ),
          Container(
            margin: new EdgeInsets.all(10),
          )
        ],
      
        ),
      )
      );
  }
}