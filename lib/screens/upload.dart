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

class UploadScreen extends StatefulWidget {
  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  FlutterVideoCompress _videoCompress = FlutterVideoCompress();
  Subscription _subscription;
  double _progressState = 0;
  String _taskName;

  @override
  void initState() {
    super.initState();
    _subscription =
        _videoCompress.compressProgress$.subscribe((progress) {
      setState(() {
        _progressState = progress;
      });
    });
  }


  Future getVideo() async{
    
    
    File video = await ImagePicker.pickVideo(source: ImageSource.gallery);
    if(video!=null){
      uploadToFirebaseStorage(video);
    }
    
  }

  Future<void> compressVideo(File video) async{
    _taskName = '---Compressing Video---';
    final compressedVideo = await _videoCompress.compressVideo(
      video.path,
      quality: VideoQuality.DefaultQuality,
      deleteOrigin: false,
    );
    _taskName = null;
    print('DONE!');
    uploadToFirebaseStorage(compressedVideo.file);
  }

  Future<void> uploadToFirebaseStorage(File video) async{
    String basename = p.basename(video.path);
    StorageReference storageRef = FirebaseStorage.instance.ref().child("upload/$basename");
    final StorageUploadTask uploadTask = storageRef.putFile(video);
  }



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
            child: SizedBox(
              width: 150.0,
          height: 100.0,
          child: RaisedButton(
            onPressed: (){
              getVideo();
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
      /* body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            if (_taskName != null)
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text('[$_taskName] $_progressState％'),
              ),
            Padding(
                padding: const EdgeInsets.all(8),
                child: Text('Demo text'),
              ),
            SizedBox(
          width: 150.0,
          height: 100.0,
          child: RaisedButton(
            onPressed: (){
              getVideo();
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
          ]  
        )
      )
    );
  }
}
 */
