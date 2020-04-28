//This is the UI for the responces for a story
import 'package:flutter/material.dart';
import 'package:Sycle/shared/size_config.dart';

class ResponseScreen extends StatefulWidget {
  @override
  _ResponseScreenState createState() => _ResponseScreenState();
}

class _ResponseScreenState extends State<ResponseScreen> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Container(
        //Video playback
        color: Colors.black,
      child: Column(
        children: <Widget>[
          Container(
            //topBar
            color: Colors.black,
            height: 80,
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
                fontSize: 18,
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
            margin: new EdgeInsets.all(.01),
            color: Colors.black,
            height: SizeConfig.safeBlockVertical * 5,
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
            height: SizeConfig.safeBlockVertical * 4,
            child: Text('Location',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontFamily: 'Avenir',
              fontSize: 20
              )),
              alignment: Alignment(-.85, 0.5),
          ),
          //Main area
          Container(
            height:SizeConfig.safeBlockVertical * 73,
            child: Expanded(child: Row(children: <Widget>[
            //Tap for previous item
            Container(
              margin: new EdgeInsets.all(1),
              width: SizeConfig.safeBlockHorizontal * 7,
              color: Colors.yellow,
              alignment: Alignment(0, 0.35),
            ),
            //Like area 
            Expanded(
              child: Container(
              margin: new EdgeInsets.all(1),
              width: SizeConfig.safeBlockHorizontal * 200,
              color: Colors.green,
              alignment: Alignment(0, 0.35),
              )
            ),
            //Tap for next item
            Container(
              margin: new EdgeInsets.all(1),
              width: SizeConfig.safeBlockHorizontal * 7,
              color: Colors.yellow,
              alignment: Alignment(.7, 0.5),
            ),
          ],)),
          ),
          //Bottom UI
          Container(
            margin: new EdgeInsets.all(1),
            color: Colors.black,
            child: Text('Caption',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 18
              ),
            ),
            alignment: Alignment(-.85, 0.5),
          ),
        ],
      
        ),
      )
      );
  }
}