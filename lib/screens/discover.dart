import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sycle/services/db.dart';
import 'package:sycle/services/globals.dart';
import 'package:sycle/services/models.dart';


class DiscoverPage extends StatefulWidget {
  @override
  _DiscoverPageState createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
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
      body: _getTopics(context),
    );  
  }

  Widget _getTopics(BuildContext context){
    //return StreamBuilder<QuerySnapshot>(
      //pull topics one time
      return FutureBuilder(
      future: Global.topicsFirestore.getTopics(),
      builder: (context, snapshot){
        if(!snapshot.hasData) return LinearProgressIndicator();
        List<Topic> topics = snapshot.data;
        return _buildNewsFeed(context, topics);
      },
    );
  } 

  Widget _buildNewsFeed(BuildContext context, List<Topic> topics){
  //Widget _buildNewsFeed(BuildContext context, List<DocumentSnapshot> snapshot){
    //return ListView.builder(
    return ListView(
      children: topics.map((data) => _buildNewsFeedItem(context, data)).toList()
    );
  }     

  Widget _buildNewsFeedItem(BuildContext context, Topic data){
    return GestureDetector(
      onTap: (){
         Navigator.pushNamed(context, '/respond');
      },
      child: Container(
      height: 400,
      margin: EdgeInsets.only(top: 2.0),
        child: Card (
          child: Container(
            padding: const EdgeInsets.all(16.0),            
            //this is still working code; supposed to wrap image around card hsape so that it'll have rounded edges
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/${data.img}'),
                fit: BoxFit.fitHeight,
                alignment: Alignment.centerLeft
              ), 
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(data.title, style: TextStyle(fontSize: 14, color: Colors.black, fontFamily: "avenir",)),
                Text(data.description, style: TextStyle(fontSize: 30, color: Colors.black, fontFamily: "avenir",))  
              ],
            ), 
          ),  
        ),
      )
    );
  } 
}
