import 'package:Sycle/screens/responses.dart';
import 'package:Sycle/screens/screens.dart';
import 'package:Sycle/shared/scale_route.dart';
import 'package:Sycle/shared/size_config.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:path/path.dart' as p;


class CreateScreen extends StatefulWidget {
  final String topicId;
  final String topicName;

  CreateScreen(this.topicId, this.topicName);

  @override
  _CreateScreenState createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  @override
  Widget build(BuildContext context) {
    String topicId = widget.topicId;
    String topicName = widget.topicName;
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark, 
        iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
        elevation: .2,
        backgroundColor: Colors.white,
         title: Text('Add a Response',
         style: TextStyle(
           color: Colors.black,
           fontFamily: "Avenir",
          fontWeight: FontWeight.w900,
         ),
        ),
      ),
      body: Center(
       child: Column(
        children: <Widget>[
          Container(height: SizeConfig.safeBlockVertical * 4,),
          Card(
         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: new AspectRatio(aspectRatio: 1800 / 700,
        //Remove this when you put it into a listview. This is just test code
              child: InkWell(
              onTap: () => Navigator.pushNamed(context, '/upload'),
              //Testcode ends
                  child: Container(
                    margin: new EdgeInsets.all(0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                //Put the images from the listview
                    image: DecorationImage(
                      image: AssetImage('assets/images/Capture.png'),
                      fit: BoxFit.cover
                      )
                    ), 
                  ),
                )
              )
            ),
            Container(height: SizeConfig.safeBlockVertical * 1,),
            Card(
         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: new AspectRatio(aspectRatio: 1800 / 700,
        //Remove this when you put it into a listview. This is just test code
              child: InkWell(
              onTap: () => {
                getImage().then((file) => {
                  if(file != null){
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => UploadScreen(topicId, topicName, file)
                    ))
                  }
                })
              },
              //Testcode ends
                  child: Container(
                    margin: new EdgeInsets.all(0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                //Put the images from the listview
                    image: DecorationImage(
                      image: AssetImage('assets/images/Gallery.png'),
                      fit: BoxFit.cover
                      )
                    ), 
                  ),
                )
              )
            ),
          ]
        )
      )
    );
  }

  Future<File> getImage() async{
    File image = await ImagePicker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    if(image != null){
      return image;  
    }else{
      return null;
    }
  }
}