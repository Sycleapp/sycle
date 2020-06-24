//This is the UI for the responces for a story
import 'package:Sycle/screens/profile.dart';
import 'package:flutter/material.dart';
import 'package:Sycle/shared/size_config.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../services/services.dart';
import 'package:provider/provider.dart';

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
              IconButton(icon: Icon(Icons.person_outline, color: Colors.white,), onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context){
                return StreamProvider<User>.value(
                  value: Global.userRef.documentStream,
                  child: ProfileScreen()
                );
              }));},),
        ],
      ),
      ),

      body: _buildResponsesItems(context)
    );
  }

  Widget _buildResponsesItems(BuildContext context) {
    return Container(
      //Video playback
        decoration: _buildBackgroundImage(context, 'https://payparitypost.com/wp-content/uploads/2019/12/AdobeStock_253908855_1280px.jpg'),
    child: Column(
      children: <Widget>[
        Container(
          height: SizeConfig.safeBlockVertical * 1,
        ),
        Container(
          //topBar
          color: Colors.transparent,
          height: SizeConfig.safeBlockVertical * 12,
          
          child: Center(
            child: Row(
              children: <Widget>[
                DiscoverRouteComponent(),
                TopicNameComponent('Topic Name'),
                CreateRouteComponent()
              ],
            )
          )
        ),
        //Main area
        Container(
          child: Expanded(
            child: Row(
              children: <Widget>[
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
              ],
            )
          )
        ),
        //Bottom UI
        NameComponent('Name'),
        CaptionComponent('Hello World'),
        LocationComponent('LOCATION'),        
        Container(height: SizeConfig.safeBlockVertical * 1,)
      ],
    ),
    );
  }
}

BoxDecoration _buildBackgroundImage(BuildContext context, String imageUrl){
  return new BoxDecoration(
    color: const Color(0xff7c94b6),
    image: new DecorationImage(
      fit: BoxFit.cover,
      colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.dstATop),
      image: new NetworkImage(
        imageUrl,
      ),
    ),
  );
}

class NameComponent extends StatelessWidget{
  final String displayName;

  NameComponent(this.displayName);

  @override
  Widget build(BuildContext context){
    return Container(
      margin: new EdgeInsets.all(1),
      color: Colors.transparent,
      height: SizeConfig.safeBlockVertical * 4,
      alignment: Alignment(-.9, 0),
      child: Text(
        displayName,
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
        )
      ),
    );
  }
}

class CaptionComponent extends StatelessWidget{
  final String caption;

  CaptionComponent(this.caption);

  @override
  Widget build(BuildContext context){
    return Container(
      margin: new EdgeInsets.all(1),
      color: Colors.transparent,
      height: SizeConfig.safeBlockVertical * 5,
      alignment: Alignment(-.9, 0),
      child: Text(
        caption,
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
        )
      ),
    );
  }
}

class LocationComponent extends StatelessWidget{
  final String location;

  LocationComponent(this.location);

  @override
  Widget build(BuildContext context){
    return Container(
      margin: new EdgeInsets.all(1),
      color: Colors.transparent,
      height: SizeConfig.safeBlockVertical * 4,
      alignment: Alignment(-.9, 0),
      child: Text(
        location,
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
        )
      ),
    );
  }
}

class DiscoverRouteComponent extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return Container(
      margin: new EdgeInsets.all(3),
      width: SizeConfig.safeBlockHorizontal * 8,
      color: Colors.transparent,
      alignment: Alignment.center,
      child: IconButton(
        icon: Icon(Icons.search),
        iconSize: 28,
        color: Colors.white,
        onPressed: () {
          Navigator.pushNamed(context, '/discover');
        },
      ),
    );
  }
}

class TopicNameComponent extends StatelessWidget{
  final String topicName;

  TopicNameComponent(this.topicName);

  @override
  Widget build(BuildContext context){
    return Container(
      width: SizeConfig.safeBlockHorizontal * 78,
      color: Colors.transparent,
      alignment: Alignment.center,
      child: Text(
        topicName,
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
    );
  }
}

class CreateRouteComponent extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return Container(
      margin: new EdgeInsets.all(3),
      width: SizeConfig.safeBlockHorizontal * 8,
      color: Colors.transparent,
      alignment: Alignment.center,
      child: IconButton(
        icon: Icon(Icons.add_circle_outline),
        color: Colors.white,
        iconSize: 28,
        onPressed: () {
          Navigator.pushNamed(context, '/create');
        }
      ),
    );
  }
}





