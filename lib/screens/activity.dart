import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:Sycle/services/db.dart';
import 'package:provider/provider.dart';
import 'package:Sycle/services/models.dart';

class ActivityScreen extends StatefulWidget {
  @override
  _ActivityScreenState createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  //initiate helper object from db.dart to deal with subcollections
  Database _firestore = Database();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        brightness: Brightness.light, 
        iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
        elevation: .2,
        backgroundColor: Colors.white,
         title: Text('Activity',
         style: TextStyle(
           color: Colors.black,
           fontFamily: "Avenir",
          fontWeight: FontWeight.w600,
         ),
        ),
      ),
      body: Center(
        child: new AspectRatio(
          aspectRatio: 400 / 600,
          child: _getFeed(context)
        )
      )
    );
  }

  Widget _getFeed(BuildContext context){
    FirebaseUser user = Provider.of<FirebaseUser>(context);
    return FutureBuilder<List<Feed>>(
      future: _firestore.getFeedSubCollection(user.uid),
      builder: (context, snapshot){
        if(!snapshot.hasData || snapshot.data.length == 0) return Text('There are no activities yet.');
        List<Feed> feeds = snapshot.data;
        return _buildActivityFeed(context, feeds);
      }
    );
  }

  Widget _buildActivityFeed(BuildContext context, List<Feed> feeds){
    return ListView(
      children: feeds.map((data) => _buildActivityFeedItem(context, data)).toList()
    );
  }

  Widget _buildActivityFeedItem(BuildContext context, Feed feed){
    return ListTile(
      leading: Image.network(feed.rUserPhotoUrl),
      title: Text("${feed.rUserName} liked your response on"),
      subtitle: Text(feed.sTitle),
      trailing: Image.asset('assets/icon/LikeIconActivity.png')
    );
  }
}