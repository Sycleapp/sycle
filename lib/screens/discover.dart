import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sycle/services/db.dart';
import 'package:sycle/services/globals.dart';
import 'package:sycle/services/models.dart';
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart';


class DiscoverPage extends StatefulWidget {
  @override
  _DiscoverPageState createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  String imgURL = "https://uploads0.wikiart.org/00129/images/katsushika-hokusai/the-great-wave-off-kanagawa.jpg"; 
  
  //using Classes in models.dart: change notation from data['title'] to data.title
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        brightness: Brightness.light, 
        iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
              centerTitle: true,
              leading: IconButton(
                icon: Icon(Icons.account_circle),
                onPressed: (){
                  Navigator.pushNamed(context, '/profile');
                },
              ),
              title: Text("Discover",
              style: TextStyle(
                fontFamily: "Avenir",
                fontWeight: FontWeight.w900,
                color: Colors.black
              )),
              backgroundColor: Colors.white,
              elevation:.2,
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.notifications),
                  onPressed: () {
                    {
                  Navigator.pushNamed(context, '/activity');
                    }
                  },
                ),
              ],
            ),
      body: _getStories(context),
    );  
  }

  Widget _getStories(BuildContext context){
    List<Story> stories = Provider.of<List<Story>>(context);

    /* return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('topics').snapshots(),
      builder: (context, snapshot){
        if(!snapshot.hasData) return LinearProgressIndicator();
        return _buildNewsFeed(context, snapshot.data.documents);
      }
    ); */  
    if(stories == null){stories[0] = new Story(id: "6", category: "Movies", title: "Movies Postponed Release till Winter", img: imgURL);}
    return _buildNewsFeed(context, stories);
  } 

  /* Widget _buildNewsFeed(BuildContext context, List<DocumentSnapshot> topics){
    return ListView(
      children: topics.map((data) => _buildNewsFeedItem(context, data)).toList()
    );
  }  */

  Widget _buildNewsFeed(BuildContext context, List<Story> stories){
  //Widget _buildNewsFeed(BuildContext context, List<DocumentSnapshot> snapshot){
    //return ListView.builder(
    return ListView(
      children: stories.map((data) => _buildNewsFeedItem(context, data)).toList()
    );
  }     

  //Widget _buildNewsFeedItem(BuildContext context, DocumentSnapshot data){
  Widget _buildNewsFeedItem(BuildContext context, Story story){
    return GestureDetector(
      onTap: (){
         Navigator.pushNamed(context, '/respond');
      },
      child: Container(
      height: 400,
      margin: EdgeInsets.only(top: 2.0),
        child: Card (
          child: FutureBuilder<String>(
            future: imageRef(story.img),
            builder: (context,snapshotURL){
              if(!snapshotURL.hasData){
                return Container(child:Image.network(imgURL));
              }
              return Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(snapshotURL.data),
                    fit: BoxFit.fitHeight,
                    alignment: Alignment.centerLeft
                  )
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(story.category, style: TextStyle(fontSize: 14, color: Colors.black, fontFamily: "avenir",)),
                    Text(story.title, style: TextStyle(fontSize: 30, color: Colors.black, fontFamily: "avenir",))  
                  ],
                )
              );
            }
          ) 
        ),
      )
    );
  }

  //helper function to download image from Firebase Storage and set it as the image path
  //use a FutureBuilder to deal with async/await issues
  Future<String> imageRef(String imgPath) async{
    var imgRef = FirebaseStorage.instance.ref().child(imgPath);
    print(imgRef);
    var downloadURL = await imgRef.getDownloadURL();
    return downloadURL;
  } 
}
