//This is the UI for the responces for a story
import 'package:Sycle/screens/webview.dart';
import 'package:Sycle/services/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:video_player/video_player.dart';
import 'package:Sycle/services/db.dart';
import 'package:share/share.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:like_button/like_button.dart';
import 'package:Sycle/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'dart:async';
import 'package:Sycle/screens/upload.dart';

class ResponseScreen extends StatefulWidget {
  final Story story;
  
  ResponseScreen(this.story);

  @override
  _ResponseScreenState createState() => _ResponseScreenState();
}

class _ResponseScreenState extends State<ResponseScreen> {
  int currentPage = 0;
  PageController _controller = PageController(
    initialPage: 0,
  );

  VideoPlayerController _videoController;
  //initiate helper object from db.dart to deal with subcollections
  Database _firestore = Database();

  @override
  void dispose(){
    _controller.dispose();
    _videoController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    //take storyID passed in from previous discover page
    String reactionSID = widget.story.id;

    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('stories').document(reactionSID).collection('reactions').snapshots(),
      builder: (context, snapshot){
        if(!snapshot.hasData || snapshot.data.documents.length == 0) return _defaultReactionSlide(context);
        return _buildReactionSlide(context, snapshot.data.documents);
      }
    );
  }

  Widget _buildReactionSlide(BuildContext context, List<DocumentSnapshot> reactions){
    print("CURRENT PAGE BEFORE: $currentPage");
    Timer.periodic(Duration(seconds: 30), (Timer time){
      print("CHANGING CURRENT PAGE: $currentPage");
      if(currentPage < reactions.length){
        currentPage++;
      }

      //cancel timer after no more pages
      if(currentPage == reactions.length - 1){
        time.cancel();
      }

    print("CURRENT PAGE AFTER: $currentPage");
    _controller.animateToPage(currentPage, duration: Duration(microseconds: 1200), curve: Curves.easeIn);
    print(DateTime.now());
      
    });
    
    return PageView(
      controller: _controller,
      children: reactions.map((data) => _buildVideoReaction(context, data)).toList()
    );
  }

  Widget _buildVideoReaction(BuildContext context, DocumentSnapshot reaction){
    FirebaseUser user = Provider.of<FirebaseUser>(context);
    print("USERID ${user.uid}");
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.close),
          iconSize: 32.0,
          onPressed: (){
            Navigator.pushNamed(context, '/discover');
          },
        ),
        title: GestureDetector(
          child: Text(
            reaction['storyTitle'],
            style: TextStyle(
              fontFamily: "Avenir",
              fontWeight: FontWeight.w800,
              color: Colors.white
            )
          ),
          onTap: () => {
            //TODO: Pause video on clicking the link
            //TODO: Pause timer on clicking the link
            Navigator.of(context).push(MaterialPageRoute(
              //Plugin to open webpage within app
              builder: (BuildContext context) => WebViewPage(
                displayTitle: reaction['storyTitle'],
                urlToLoad: 'https://www.nytimes.com/' //this will be the URL to load in the app (default now is New York Times)
              )
            ))
          }
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add_circle_outline),
            iconSize: 32.0,
            onPressed: (){
              Navigator.push(
                context,
                //UploadScreen has access to Story data so that upload can write data to Firestore 
                MaterialPageRoute(builder: (context) => UploadScreen(widget.story))
              );
            }
          )
        ],
      ),
      //uncomment to play images
      /* body: FutureBuilder<String>(
            future: imageRef(reaction['video']),
            builder: (context,snapshotURL){
              if(!snapshotURL.hasData){
                print('IMAGE NOT FOUND!!!!');
                return Image.asset('assets/images/logo.png');
              } */
              
      //uncomment to play videos
      body: FutureBuilder<String>(
        future: videoRef(reaction['video']),
        builder: (context, snapshotURL){
          if(!snapshotURL.hasData) return _defaultReactionSlide(context);
          _videoController = VideoPlayerController.network(snapshotURL.data)
          ..initialize().then((_){
            _videoController.play();
            _videoController.setLooping(true);
          });
          return Stack(
            children:[
              SizedBox.expand(
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: 450,
                    height: 500,
                    //child: _imageLoader(snapshotURL)
                    child: VideoPlayer(_videoController)
                  )
                )
              ), 
              Container(
                padding: EdgeInsets.all(30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children:[
                    SizedBox(height: 45.0),
                    TopFirstRow(reaction['displayName']),  
                    TopSecondRow(reaction['location']),
                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            BottomFirstRow(reaction['caption'], snapshotURL.data),
                            LikeButtonSecondRow(reaction, user)
                          ]
                        )
                      )
                    )  
                  ]
                )
              )
            ]
          ); 
        }
      )
    );      
  }   
}

Widget _defaultReactionSlide(BuildContext context){
  return Scaffold(
    extendBodyBehindAppBar: true,
    backgroundColor: Colors.black,
    appBar: AppBar(
      centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: (){
            Navigator.of(context).pop();
          },
        ),
        title: Text('Title of Story',
          style: TextStyle(
            fontFamily: "Avenir",
            fontWeight: FontWeight.w900,
            color: Colors.white
          )
        )
      ),
    body: Container(
      padding: EdgeInsets.all(30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children:[
          SizedBox(height: 45.0),
          TopFirstRow("Felix"),  
          TopSecondRow("Mars"),
          Expanded(
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  BottomFirstRow("Hello", "Link to Sycle"),
                  BottomSecondRow("No Reactions Yet")
                ],
              )
            ) 
          )
        ]
      )
    ) 
  );      
}

//for loading images
/* Widget _imageLoader(AsyncSnapshot snapshot){
  print("DISPLAYING IMAGE: ${snapshot.data}");
  return CachedNetworkImage(
    imageUrl: snapshot.data,
    placeholder: (context,url) => LinearProgressIndicator(),
    errorWidget: (context,url,error) => Image.asset('assets/images/logo.png')
  );
} */


class TopFirstRow extends StatelessWidget{
  final String displayName;

  TopFirstRow(this.displayName);

  @override
  Widget build(BuildContext context){
    return Text(
      displayName, 
      style: TextStyle(
        fontFamily: "Avenir",
        fontWeight: FontWeight.w800,
        color: Colors.white,
        fontSize: 22,
      )
    );
  }    
}

class TopSecondRow extends StatelessWidget{
  final String location;

  TopSecondRow(this.location);

  @override
  Widget build(BuildContext context){
    return Row(
      children: [
        Padding(
          padding: EdgeInsets.only(right: 5.0),
          child: Icon(
            Icons.location_on,
            size: 32.0,
            color: Colors.white
          )
        ),
        Text(
          location, 
          style: TextStyle(
            fontFamily: "Avenir",
            fontWeight: FontWeight.w400,
            color: Colors.white,
            fontSize: 18
          )
        )
      ]
    );
  }
}

//helper function to download videos from Firebase Storage and set it as the video path
//use a FutureBuilder to deal with async/await issues
Future<String> videoRef(String vidPath) async{
  var vidRef = FirebaseStorage.instance.ref().child(vidPath);
  print(vidRef);
  var downloadURL = await vidRef.getDownloadURL();
  return downloadURL;
} 

//helper function to download image from Firebase Storage and set it as the image path
  //use a FutureBuilder to deal with async/await issues
  Future<String> imageRef(String imgPath) async{
    var imgRef = FirebaseStorage.instance.ref().child(imgPath);
    print(imgRef);
    var downloadURL = await imgRef.getDownloadURL();
    return downloadURL;
  } 


class BottomFirstRow extends StatelessWidget{
  final String caption;
  final String videoURL;

  BottomFirstRow(this.caption, this.videoURL);

  @override 
  Widget build(BuildContext context){
    return IconButton(
      icon: Icon(Icons.share),
      color: Colors.white,
      onPressed:(){
        Share.share("$caption $videoURL", subject: caption);
      }
    );     
  }  
}

class BottomSecondRow extends StatelessWidget{
  final String caption;
  
  BottomSecondRow(this.caption);

  @override
  Widget build(BuildContext context){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children:[
        Text(
          caption,
          style: TextStyle(
            fontFamily: "Avenir",
            fontWeight: FontWeight.w400,
            color: Colors.white,
            fontSize: 18
          )
        ),
        Icon(
          Icons.favorite_border,
          color: Colors.white
        ),
      ]
    );
  }  
}

class LikeButtonSecondRow extends StatefulWidget{
  final DocumentSnapshot reaction;
  final FirebaseUser user;
  
  LikeButtonSecondRow(this.reaction, this.user);

  
@override
  _LikeButtonState createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButtonSecondRow>{
  bool isTapped = false;
  Database _firestore = Database();

  @override
  Widget build(BuildContext context){
    DocumentSnapshot reaction = widget.reaction;
    FirebaseUser user = widget.user;
    List<String> clickedUsers = new List<String>.from(reaction['reactionUsers']);

    bool isRecorded = false;
    clickedUsers.forEach((rUser) => {
      if(rUser == user.uid){
        isRecorded = true
      }
    });
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children:[
        Text(
          reaction['caption'],
          style: TextStyle(
            fontFamily: "Avenir",
            fontWeight: FontWeight.w400,
            color: Colors.white,
            fontSize: 18
          )
        ),
        InkWell(
          child: Icon(
            (isTapped||isRecorded? Icons.favorite : Icons.favorite_border),
            color: (isTapped||isRecorded? Colors.red : Colors.white),
            size: 30.0
          ),
          onTap: (){
            setState((){
              if(isTapped || isRecorded){
                isTapped = false;
                isRecorded = false;
              }
              else{
                isTapped = true;
                isRecorded = true;
              }
            });
            _firestore.updateLikeInformationInFeedSubCollection(reaction, user, isTapped);
          }
        )
      ]
    );
  }  
}


