//This is the UI for the responces for a story
import 'package:Sycle/services/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:video_player/video_player.dart';
import 'package:Sycle/services/db.dart';
import 'package:share/share.dart';


class ResponseScreen extends StatefulWidget {
  final String sid;
  
  ResponseScreen(this.sid);

  @override
  _ResponseScreenState createState() => _ResponseScreenState();
}

class _ResponseScreenState extends State<ResponseScreen> {
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
    String reactionSID = widget.sid;

    return FutureBuilder<List<Reaction>>(
      future: _firestore.getReactionSubCollection(reactionSID),
      builder: (context, snapshot){
        if(!snapshot.hasData || snapshot.data.length == 0) return _defaultReactionSlide();
        List<Reaction> reactions = snapshot.data;
        return _buildReactionSlide(context, reactions);
      }
    );
  }

  Widget _buildReactionSlide(BuildContext context, List<Reaction> reactions){
    return PageView(
      controller: _controller,
      children: reactions.map((data) => _buildVideoReaction(context, data)).toList()
    );
  }

  Widget _buildVideoReaction(BuildContext context, Reaction reaction){
    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder<String>(
        future: videoRef(reaction.video),
        builder: (context, snapshotURL){
          if(!snapshotURL.hasData) return _defaultReactionSlide();
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
                    TopFirstRow(reaction.displayName),  
                    TopSecondRow(reaction.location),
                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            BottomFirstRow(reaction.caption, snapshotURL.data),
                            BottomSecondRow(reaction.caption)
                          ],
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
      
    /* return Dismissible(
    direction: DismissDirection.vertical,
    key: Key('key'),
    onDismissed: (_) => Navigator.of(context).pop(DiscoverPage),
      child: Container(
      color: Colors.green,
        child: Container(
  
        ),
      )
    ); */
}

Widget _defaultReactionSlide(){
  return Scaffold(
    backgroundColor: Colors.black,
    body: Container(
      padding: EdgeInsets.all(30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children:[
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


class TopFirstRow extends StatelessWidget{
  final String displayName;

  TopFirstRow(this.displayName);

  @override
  Widget build(BuildContext context){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children:[
        Text(
          displayName, 
          style: TextStyle(
            fontFamily: "Avenir",
            fontWeight: FontWeight.w800,
            color: Colors.white,
            fontSize: 22,
          )
        ),
        Icon(
          Icons.add_circle_outline,
          size: 32.0,
          color: Colors.white
        )  
      ]
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
          color: Colors.white,
          size: 30.0
        )
      ]
    );
  }  
}