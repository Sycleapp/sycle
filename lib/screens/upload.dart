import 'package:Sycle/screens/screens.dart';
import 'package:Sycle/shared/size_config.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:path/path.dart' as p;

class UploadScreen extends StatefulWidget {
  final String topicId;
  final String topicName;
  final File image;

  UploadScreen(this.topicId, this.topicName, this.image);

  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  final captionController = TextEditingController();
  final locationController = TextEditingController();
  
  @override
     void dispose() {
      captionController.dispose();
      locationController.dispose();
      super.dispose();
    }
  
  @override
  Widget build(BuildContext context) {
    String topicId = widget.topicId;
    String topicName = widget.topicName;
    File file = widget.image;
    FirebaseUser user = Provider.of<FirebaseUser>(context);
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        brightness: Brightness.light,
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text("Post",
            style: TextStyle(
                fontFamily: "Avenir",
                fontWeight: FontWeight.w900,
                color: Colors.black)),
        elevation: 0,
      ),
      //Display playback inside of this container
      body: Column(children: <Widget>[
        //Caption and Location. Still needs to open a keyboard and have max characters so no clipping widgets
        Container(
          margin: new EdgeInsets.all(1),
          width: SizeConfig.safeBlockHorizontal * 95,
          child: TextField(
            controller: captionController,
            maxLength: 50,
            decoration: new InputDecoration(hintText: 'Add a Caption'),
          ),
        ),
        Container(
          margin: new EdgeInsets.all(1),
          width: SizeConfig.safeBlockHorizontal * 95,
          child: TextField(
            controller: locationController,
            maxLength: 150,
            decoration: new InputDecoration(hintText: 'Add a Location'),
          ),
        ),
        //Post button. Needs to add function and then go back to responces once complete
        Container(
          height: SizeConfig.safeBlockVertical * 4,
        ),
        GestureDetector(
            onTap: () {
              String caption = captionController.text;
              String location = locationController.text;
              writeToFirebase(topicId, topicName, user, caption, location, file)
                .then((onComplete) => {
                  if(onComplete){
                    Navigator.pushNamed(context, '/responses')
                  }
                  else{
                    _showErrorMessage()
                  }
                });
            },
            child: Container(
                margin: new EdgeInsets.all(1),
                width: SizeConfig.safeBlockHorizontal * 30,
                height: SizeConfig.safeBlockVertical * 5,
                child: Center(
                  child: Text(
                    'Post',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'avenir',
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                decoration: BoxDecoration(
                  borderRadius: new BorderRadius.circular(30.0),
                  color: const Color(0xFF0037FF),
                )))
      ]),
    );
  }

  Future<bool> writeToFirebase(String topicId, String topicName, FirebaseUser user, String caption, String location, File file) async{
    bool writeSuccess = false;
    String uploaderName = user.displayName.split(" ")[0];
    int likeCount = 0;
    //reactionID will be from document creation
    List<String> responseUsers = [];
    String uploader = user.uid;

    String collectionName = 'topics';
    String subcollectionName = 'responses';

    final Firestore _db = Firestore.instance;
    DocumentReference responseRef = _db.collection(collectionName).document(topicId).collection(subcollectionName).document();
    //reactionID
    String rid = responseRef.documentID;
    DocumentReference topicRef = _db.collection(collectionName).document(topicId);

    String fileExtension = p.extension(file.path);
    String filepath = '$collectionName/$topicId/$rid$fileExtension';

    var data = 
    {
      'caption': caption,
      'likeCount': likeCount,
      'location': location,
      'responseContent': filepath,
      'responseID': rid,
      'responseUsers': responseUsers,
      'topicID': topicId,
      'topicName': topicName,
      'uploaderID': uploader,
      'uploaderName': uploaderName
    };

    try{
      responseRef.setData(data)
        .whenComplete(() => {
        writeSuccess = true
      })
        .catchError((e) => writeSuccess = false);   
    }
    catch(e){
      return false;
    }

    if(writeSuccess){
      topicRef.updateData(
        {
          'responseCount': FieldValue.increment(1)
        }                    
      );
      bool completeFileUpload = await uploadToFirebaseStorage(file, filepath, responseRef, topicRef);
      return completeFileUpload;
    }
    else{
      return false;
    }
  }

  Future<bool> uploadToFirebaseStorage(File file, String filepath, DocumentReference responseReference, DocumentReference topicReference) async{
    //this will store data under this path in Firebase Storage
    StorageReference storageRef = FirebaseStorage.instance.ref().child(filepath);
    //storageRef.putFile(file);
    final StorageUploadTask uploadTask = storageRef.putFile(file);
    final StorageTaskSnapshot storageSnapshot = await uploadTask.onComplete;
    String imageUrl = await storageSnapshot.ref.getDownloadURL();
    //need to handle error events
    if(imageUrl == null){
        responseReference.delete();
        topicReference.updateData(
          {
            'responseCount': FieldValue.increment(-1)
          }                    
        );
        return false;
    }else{
      return true;
    }
  }

  Future<void> _showErrorMessage() async {
  return showDialog<void>(
    context: context,
    barrierDismissible: true, 
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Oops!'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Sorry, an error has occurred.'),
              Text('Would you like to try again?'),
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('Back'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
  }
}
