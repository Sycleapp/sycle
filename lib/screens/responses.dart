//This is the UI for the responces for a story
import 'package:Sycle/screens/profile.dart';
import 'package:flutter/material.dart';
import 'package:Sycle/shared/size_config.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../services/services.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:firebase_storage/firebase_storage.dart';

class ResponseScreen extends StatefulWidget {
  @override
  _ResponseScreenState createState() => _ResponseScreenState();
}

class _ResponseScreenState extends State<ResponseScreen> {
  PageController _controller = PageController(
    initialPage: 0,
  );

  int _index;
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
    List<Topic> topics = Provider.of<List<Topic>>(context); 
    
    return _buildTopics(context, topics);
    
  }

  Widget _buildTopics(BuildContext context, List<Topic> topics){
    return PageView(
      controller: _controller,
      scrollDirection: Axis.vertical,
      onPageChanged: (index){
        setState(() {
          _index = 0;
        });        
      },
      children: topics.map((data) => _buildTopicItems(context, data)).toList() 
    );
  }

  Widget _buildTopicItems(BuildContext context, Topic topic){
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('topics').document(topic.id).collection('responses').snapshots(),
      builder: (context, snapshot){
        if(!snapshot.hasData || snapshot.data.documents.length == 0){
          return _buildResponseItems(context, defaultImgUrl, 'Topic Name', 'Name', 'null', 'Hello World', 'LOCATION');
        } 
        return _buildResponseStack(context, snapshot.data.documents);
      }
    );
  }

  Widget _buildResponseStack(BuildContext context, List<DocumentSnapshot> responses){
    Timer.periodic(Duration(seconds: 5), (Timer time){
      if(_index < responses.length - 1){
        setState(() {
          _index += 1;
        });
      }

      //cancel timer after no more pages
      if(_index == responses.length - 1){
        time.cancel();
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
          return _buildResponseItems(context, defaultImgUrl, 'Topic Name', 'Name', 'null', 'Hello World', 'LOCATION');
        }
        return _buildResponseItems(context, snapshotUrl.data, response['topicName'], response['uploaderName'], response['uploaderID'], response['caption'], response['location']);
      }
    ); 
  }
  
  Widget _buildResponseItems(BuildContext context, String responseImgUrl, String topicName, String uploaderName, String uploaderId, String caption, String location){
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
        NameComponent(uploaderName, uploaderId),
        CaptionComponent(caption),
        LocationComponent(location),        
        Container(height: SizeConfig.safeBlockVertical * 1,)
      ],
    ),
    );
  }

   Future<String> imageRef(String imgPath) async{
    var imgRef = FirebaseStorage.instance.ref().child(imgPath);
    print(imgRef);
    var downloadURL = await imgRef.getDownloadURL();
    return downloadURL;
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





