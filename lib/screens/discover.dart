import 'package:Sycle/screens/responses.dart';
import 'package:Sycle/screens/upload.dart';
import 'package:flutter/material.dart';
import 'package:Sycle/services/models.dart';
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:Sycle/screens/camera.dart';


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
            color: Colors.black, 
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
              elevation: 0,
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
      body: Center(
        child: new AspectRatio(
          aspectRatio: 400 / 600,
          child: _getStories(context)
        )
      )
    );
  }

  Widget _getStories(BuildContext context){
    List<Story> stories = Provider.of<List<Story>>(context);

    //first iteration of Firebase connection
    //code for when not using provider library
    /*  return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('stories').snapshots(),
      builder: (context, snapshot){
        if(!snapshot.hasData) return LinearProgressIndicator();
        return _buildNewsFeed(context, snapshot.data.documents);
      }
    );  */

    //For Testing Purposes - load fake data if not connected to Firebase
    //if(stories == null){stories[0] = new Story(id: "6", category: "Movies", title: "Movies Postponed Release till Winter", img: imgURL);}
    return _buildNewsFeed(context, stories);
  } 

   //code for when not using provider library
  /* Widget _buildNewsFeed(BuildContext context, List<DocumentSnapshot> stories){
    return ListView(
      children: stories.map((data) => _buildNewsFeedItem(context, data)).toList()
    );
  }  */

  Widget _buildNewsFeed(BuildContext context, List<Story> stories){
    return ListView(
      children: stories.map((data) => _buildNewsFeedItem(context, data)).toList()
    );
  }     

  //code for when not using provider library
  //Widget _buildNewsFeedItem(BuildContext context, DocumentSnapshot data){
  Widget _buildNewsFeedItem(BuildContext context, Story data){
    return GestureDetector(
      onTap: () => {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ResponseScreen(data)))
      },
      child: Container(
        margin: new EdgeInsets.all(7),
        alignment: Alignment.center,
        child: Card (
          child: FutureBuilder<String>(
            future: imageRef(data.img),
            builder: (context,snapshotURL){
              if(!snapshotURL.hasData){
                return Container(child:Image.network(imgURL));
              }
              return CachedNetworkImage(
                imageUrl: snapshotURL.data,
                imageBuilder:(context, imageProvider) =>
                  Container(
                    padding: const EdgeInsets.all(15.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.fitHeight,
                        alignment: Alignment.bottomLeft
                      )
                    ),
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: 540,
                          child: new Text(
                            data.category,
                            style: new TextStyle(
                              fontFamily: "Avenir",
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                              fontSize: 18
                            ),
                          ),
                          alignment: Alignment(-0.92, .99),
                        ),
                        Container(
                          child: new Text(
                            data.title,
                            style: new TextStyle(
                              fontFamily: "Avenir_Black",
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              fontSize: 33,
                            ),
                          ),
                          alignment: Alignment(-0.85, 0.99),
                        )
                      ],
                    )
                  ),
                placeholder: (context, url) => LinearProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error),
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

   
