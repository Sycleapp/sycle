import 'package:flutter/material.dart';
import '../services/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class ActivityScreen extends StatefulWidget {
  @override
  _ActivityScreenState createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  //initiate helper object from db.dart to deal with subcollections
  DataServices _firestore = DataServices();

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
          fontWeight: FontWeight.w900,
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
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('users').document(user.uid).collection('feeds').snapshots(),
      builder: (context, snapshot){
        if(!snapshot.hasData || snapshot.data.documents.length == 0) return Text('There are no activities yet.');
        List<DocumentSnapshot> feeds = snapshot.data.documents;
        return _buildActivityFeed(context, feeds);
      }
    );
  }

  Widget _buildActivityFeed(BuildContext context, List<DocumentSnapshot> feeds){
    return ListView(
      children: feeds.map((data) => _buildActivityFeedItem(context, data)).toList()
    );
  }

  Widget _buildActivityFeedItem(BuildContext context, DocumentSnapshot feed){
    return ListTile(
      leading: CircleAvatar(backgroundImage: NetworkImage(feed['clickerPhotoURL'])),
      title: Text("${feed['clickerName']} liked your response on"),
      subtitle: Text(feed['topicName']),
      trailing: Image.asset('assets/icon/LikeIconActivity.png')
    );
  }
}