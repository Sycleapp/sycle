//This is the UI for the responces for a story
import 'package:flutter/material.dart';
import 'package:Sycle/shared/size_config.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ResponseScreen extends StatefulWidget {
  @override
  _ResponseScreenState createState() => _ResponseScreenState();
}

class _ResponseScreenState extends State<ResponseScreen> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
          color: Colors.black,
          child: new Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
              IconButton(icon: Icon(Icons.home, color: Colors.white,), onPressed: () {},),
              IconButton(icon: Icon(FontAwesomeIcons.heart, color: Colors.white,), onPressed: () {Navigator.pushNamed(context, '/activity');},),
              IconButton(icon: Icon(Icons.person_outline, color: Colors.white,), onPressed: () {Navigator.pushNamed(context, '/profile');},),
        ],
      ),
      ),

      body: Container(
        //Video playback
          decoration: new BoxDecoration(
              color: const Color(0xff7c94b6),
              image: new DecorationImage(
                fit: BoxFit.cover,
                colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.dstATop),
                image: new NetworkImage(
                  'https://payparitypost.com/wp-content/uploads/2019/12/AdobeStock_253908855_1280px.jpg',
                ),
              ),
            ),
      child: Column(
        children: <Widget>[
          Container(
            height: SizeConfig.safeBlockVertical * 1,
          ),
          Container(
            //topBar
            color: Colors.transparent,
            height: SizeConfig.safeBlockVertical * 12,
            
            child: Center(child: Row(children: <Widget>[
              Container(
                margin: new EdgeInsets.all(3),
                width: SizeConfig.safeBlockHorizontal * 8,
                color: Colors.transparent,
                child: IconButton(
                  icon: Icon(Icons.search),
                  iconSize: 28,
                  color: Colors.white,
                  onPressed: () {
                    {
                      Navigator.pushNamed(context, '/discover');
                    }
                  },
                ),
                alignment: Alignment.center
              ),
              Container(
                  width: SizeConfig.safeBlockHorizontal * 78,
                
                  color: Colors.transparent,
                  child: Text('Topic name',
                    style: TextStyle(
                    fontFamily: 'Avenir',
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    color: Colors.white,
                    shadows: <Shadow>[
                    Shadow(
                      offset: Offset(.25, .25),
                      blurRadius: 0,
                      color: Color.fromARGB(255, 0, 0, 0),
                      ),           
                    ]
                  ),
                ),
                alignment: Alignment.center
                  ),
              Container(
                margin: new EdgeInsets.all(3),
                width: SizeConfig.safeBlockHorizontal * 8,
                color: Colors.transparent,
                child: IconButton(
                  icon: Icon(Icons.add_circle_outline),
                  color: Colors.white,
                  iconSize: 28,
                  onPressed: () {
                    {
                  Navigator.pushNamed(context, '/create');
                    }
                  },
                ),
                alignment: Alignment.center
              )
            ],
            )
            )
          ),
          //Main area
          Container(
            child: Expanded(child: Row(children: <Widget>[
            //Tap for previous item
            Container(
              margin: new EdgeInsets.all(1),
              width: SizeConfig.safeBlockHorizontal * 8,
              color: Colors.transparent,
              alignment: Alignment(0, 0.35),
            ),
            //Like area 
            Container(
              child: Container(
              margin: new EdgeInsets.all(1),
              width: SizeConfig.safeBlockHorizontal * 81,
              color: Colors.transparent,
              alignment: Alignment(0, 0.35),
              )
            ),
            //Tap for next item
            Container(
              margin: new EdgeInsets.all(1),
              width: SizeConfig.safeBlockHorizontal * 8,
              color: Colors.transparent,
              alignment: Alignment(.7, 0.5),
            ),
          ],))),
          //Bottom UI
          Container(
            margin: new EdgeInsets.all(1),
            color: Colors.transparent,
            height: SizeConfig.safeBlockVertical * 4,
            child: Text('Name',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontFamily: 'Avenir',
              fontSize: 20,
              shadows: <Shadow>[
                    Shadow(
                      offset: Offset(.5, .5),
                      blurRadius: 0,
                      color: Color.fromARGB(255, 0, 0, 0),
                      ),           
                    ]
              )),
              alignment: Alignment(-.9, 0),
            ),
          Container(
            margin: new EdgeInsets.all(1),
            color: Colors.transparent,
            height: SizeConfig.safeBlockVertical * 5,
            child: Text('Caption',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontFamily: 'Avenir',
              fontSize: 16,
              shadows: <Shadow>[
                    Shadow(
                      offset: Offset(.25, .25),
                      blurRadius: 0,
                      color: Color.fromARGB(255, 0, 0, 0),
                      ),           
                    ]
              )),
              alignment: Alignment(-.9, 0),
            ),
           Container(
            margin: new EdgeInsets.all(1),
            color: Colors.transparent,
            height: SizeConfig.safeBlockVertical * 4,
            child: Text('LOCATION',
            style: TextStyle(
              shadows: <Shadow>[
                    Shadow(
                      offset: Offset(.25, .25),
                      blurRadius: .5,
                      color: Color.fromARGB(255, 0, 0, 0),
                      ),           
                    ],
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontFamily: 'Avenir',
              fontSize: 14
              )),
              alignment: Alignment(-.9, 0),
            ),
            Container(height: SizeConfig.safeBlockVertical * 1,)
          ],
        ),
      )
    );
  }
}