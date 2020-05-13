//working with Files
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:path/path.dart' as p;

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter_video_compress/flutter_video_compress.dart';
import '../services/services.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class UploadScreen extends StatefulWidget {
  final Story story;
  UploadScreen(this.story);
  
  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  //NOTE: code for video upload
  /* FlutterVideoCompress _videoCompress = FlutterVideoCompress();

  Future getVideo() async{
    File video = await ImagePicker.pickVideo(source: ImageSource.gallery);
    if(video!=null){
      //uploadToFirebaseStorage(video);
      compressVideo(video);
    }   
  } 
  
  Future<void> compressVideo(File video) async{
    final compressedVideo = await _videoCompress.compressVideo(
      video.path
    );
    uploadToFirebaseStorage(compressedVideo.file);
  }
  */

  Future getImage(FirebaseUser user) async{
    File image = await ImagePicker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    if(image!=null){
      uploadToFirebaseStorage(image, user);
    }
  }

  Future<void> uploadToFirebaseStorage(File video, FirebaseUser user) async{
    String basename = p.basename(video.path);
    String filePath = "reactions/test/$basename";
    StorageReference storageRef = FirebaseStorage.instance.ref().child(filePath);
    //StorageReference storageRef = FirebaseStorage.instance.ref().child("test/$basename-TEST-2");
    storageRef.putFile(video);
    //final StorageUploadTask uploadTask = storageRef.putFile(video);
    writeToFirebase(filePath, user);
    //if(uploadTask.isSuccessful){ writeToFirebase(filePath); }
  }

  Future<void> writeToFirebase(String filePath, FirebaseUser user) async{
    String caption = "Test Caption"; //need to change to user's input
    String uploaderName = user.displayName.split(" ")[0];
    int likeCount = 0;
    String location = "Test Location"; //need to change to user's input
    //reactionID will be from document creation
    List<String> reactionUsers = [];
    String sid = widget.story.id;
    String sTitle = widget.story.title;
    String uploader = user.uid;
    String storagePath = filePath;

    final Firestore _db = Firestore.instance;
    DocumentReference docRef = _db.collection('stories').document(sid).collection('reactions').document();
    //reactionID
    String rid = docRef.documentID;

    var data = 
    {
      'caption': caption,
      'displayName': uploaderName,
      'likeCount': likeCount,
      'location': location,
      'reactionID': rid,
      'reactionUsers': reactionUsers,
      'storyID': sid,
      'storyTitle': sTitle,
      'userID': uploader,
      'video': storagePath
    };

    docRef.setData(data);    
  }

  @override
  Widget build(BuildContext context) {
    FirebaseUser user = Provider.of<FirebaseUser>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        brightness: Brightness.light, 
        iconTheme: IconThemeData(
            color: Colors.black, 
          ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.black,
          onPressed: (){
            Navigator.of(context).pop();
          },
        ),
        title: Text("Upload",
          style: TextStyle(
            fontFamily: "Avenir",
            fontWeight: FontWeight.w900,
            color: Colors.black
          )
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center(
        child: SizedBox(
              width: 150.0,
          height: 100.0,
          child: RaisedButton(
            onPressed: (){
              //getVideo();
              getImage(user);
            },
            color: Colors.blue,
            child: Text(
              'Choose File',
              style: TextStyle(
                fontSize: 20.0
              )
            )
          )
            )
          )
        );
  }
}
     