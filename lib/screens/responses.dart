//This is the UI for the responces for a story
import 'dart:io';

import 'package:Sycle/screens/profile.dart';
import 'package:flutter/material.dart';
import 'package:Sycle/shared/size_config.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../services/services.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:Sycle/screens/create.dart';

class ResponseScreen extends StatefulWidget {
  @override
  _ResponseScreenState createState() => _ResponseScreenState();
}

class _ResponseScreenState extends State<ResponseScreen> {
  PageController _controller = PageController(
    initialPage: 0,
  );

  int _index;
  int numOfResponses;
  String defaultImgUrl = 'https://payparitypost.com/wp-content/uploads/2019/12/AdobeStock_253908855_1280px.jpg';

  @override
  void initState(){
    super.initState();
    _index = 0;

  }

  @override
  void dispose(){
    _controller.dispose();
    super.dispose();
  }

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
                  initialData: User.initialData(),
                  value: Global.userRef.documentStream,
                  child: ProfileScreen(true)
                );
              }));},),
        ],
      ),
      ),

      body: _getTopics(context)
    );
  }

  Widget _getTopics(BuildContext context){
    //change from futurebuilder to streambuilder
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('topics').snapshots(),
      builder: (context, snapshot){
        if(!snapshot.hasData) return LinearProgressIndicator();
        return _buildTopics(context, snapshot.data.documents);
      }
    ); 
  }

  Widget _buildTopics(BuildContext context, List<DocumentSnapshot> topics){
    return PageView(
      controller: _controller,
      scrollDirection: Axis.vertical,
      onPageChanged: (page) {
        Firestore.instance.collection('topics').document(topics[page].documentID).get().then((document) => {
          setState((){
            _index = 0;
            numOfResponses = document.data['responseCount'];
          })            
        });        
      },
      children: topics.map((data) => _buildTopicItems(context, data)).toList() 
    );
  }

  Widget _buildTopicItems(BuildContext context, DocumentSnapshot topic){
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('topics').document(topic['topicID']).collection('responses').snapshots(),
      builder: (context, snapshot){
        if(!snapshot.hasData || snapshot.data.documents.length == 0){
          return _buildResponseItems(context, defaultImgUrl, 'Topic Name', 'Name', 'null', 'Hello World', 'LOCATION', 'null');
        } 
        return _buildResponseStack(context, snapshot.data.documents);
      }
    );
  }

  Widget _buildResponseStack(BuildContext context, List<DocumentSnapshot> responses){
    numOfResponses = responses.length;

    Timer.periodic(Duration(seconds: 5), (Timer time){
      if(_index < numOfResponses - 1){
        setState(() {
          _index += 1;
          print('SWITCHED TO WIDGET: $_index, GETTIME: ${DateTime.now()}');
        });
      }

      //cancel timer after no more pages
      if(_index == numOfResponses - 1){
        time.cancel();
        print('!!!!!END!!!! ON WIDGET: $_index, GETTIME: ${DateTime.now()}');
      }
    });

    return IndexedStack(
      index: _index,
      children: responses.map((data) => _buildResponseSlide(context, data)).toList()
    );
  }

  

  Widget _buildResponseSlide(BuildContext context, DocumentSnapshot response){
    return FutureBuilder<String>(
      future: imageRef(response['responseContent']),
      builder: (context, snapshotUrl){
        if(!snapshotUrl.hasData){
          return _buildResponseItems(context, defaultImgUrl, 'Topic Name', 'Name', 'null', 'Hello World', 'LOCATION', 'null');
        }
        return _buildResponseItems(context, snapshotUrl.data, response['topicName'], response['uploaderName'], response['uploaderID'], response['caption'], response['location'], response['topicID']);
      }
    ); 
  }
  
  Widget _buildResponseItems(BuildContext context, String responseImgUrl, String topicName, String uploaderName, String uploaderId, String caption, String location, String topicId){
    return Container(
      //Video playback
        decoration: new BoxDecoration(
              color: const Color(0xff7c94b6),
              image: new DecorationImage(
                fit: BoxFit.cover,
                colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.dstATop),
                image: new NetworkImage(
                  responseImgUrl,
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
          
          child: Center(
            child: Row(
              children: <Widget>[
                DiscoverRouteComponent(),
                TopicNameComponent(topicName),
                CreateRouteComponent(topicId, topicName)
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
        BottomFirstRow(uploaderName, uploaderId, caption),        
        LocationComponent(location),        
        Container(height: SizeConfig.safeBlockVertical * 1,)
      ],
    ),
    );
  }

  Future<String> imageRef(String imgPath) async{
    var imgRef = FirebaseStorage.instance.ref().child(imgPath);
    var downloadURL = await imgRef.getDownloadURL();
    return downloadURL;
  } 
}

class BottomFirstRow extends StatelessWidget{
  final String uploaderName;
  final String uploaderId;
  final String caption;
  
  BottomFirstRow(this.uploaderName, this.uploaderId, this.caption);

  @override
  Widget build(BuildContext context){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: new EdgeInsets.only(left: 15.0),
              child: NameComponent(uploaderName, uploaderId)
            ),
            Padding(
              padding: new EdgeInsets.only(left: 10.0),
              child: CaptionComponent(caption)
            )
          ],
        ),
        Padding(
          padding: new EdgeInsets.only(right: 15.0),
          child: LikeComponent()
        )
      ],
    );
  }
}

class NameComponent extends StatelessWidget{
  final String displayName;
  final String uploaderId;

  NameComponent(this.displayName, this.uploaderId);

  @override
  Widget build(BuildContext context){
    return Container(
      margin: new EdgeInsets.all(1),
      color: Colors.transparent,
      height: SizeConfig.safeBlockVertical * 4,
      alignment: Alignment(-.9, 0),
      child: GestureDetector(
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
        onTap: () => {
          if(uploaderId != 'null'){
            Navigator.push(context, MaterialPageRoute(builder: (context){
                return StreamProvider<User>.value(
                  initialData: User.initialData(),
                  value: Global.userRef.specificDocumentStream(uploaderId),
                  child: ProfileScreen(false)
                );
            }))
          }          
        },
      )
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

class LikeComponent extends StatelessWidget{
  //needs to get the response object
  //rewrite code in DataServices class
  
  @override
  Widget build(BuildContext context){
    FirebaseUser user = Provider.of<FirebaseUser>(context);
    
    return Icon(
      Icons.favorite,
      color: Colors.red,
      size: 48.0,
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
  final String topicId;
  final String topicName;

  CreateRouteComponent(this.topicId, this.topicName);

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
          if(topicId != 'null' && topicName != 'null'){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CreateScreen(topicId, topicName)));
          }
          else{
            Navigator.pushNamed(context, '/responses');
          }          
        }
      ),
    );
  } 
}





