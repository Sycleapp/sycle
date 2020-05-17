import 'dart:io';

import 'package:Sycle/camera/video_preview.dart';
import 'package:Sycle/shared/size_config.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';

class UploadScreen extends StatefulWidget {
  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
      String currentFilePath;
  @override
  Widget build(BuildContext context) {
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
                onPressed: (){
                  Navigator.pushNamed(context, '/camera');
                },
              ),
              title: Text("Post",
              style: TextStyle(
                fontFamily: "Avenir",
                fontWeight: FontWeight.w900,
                color: Colors.black
              )),
              elevation: 0,
            ),
      body: Column(
        children: <Widget>[
          //How to show video, keep the image code inside for future updates. You can just comment it our.
      FutureBuilder(
        future: _getAllImages(),
        builder: (context, AsyncSnapshot<List<FileSystemEntity>> snapshot) {
          if (!snapshot.hasData || snapshot.data.isEmpty) {
            return Container();
          }
          print('${snapshot.data.length} ${snapshot.data}');
          if (snapshot.data.length == 0) {
            return Center(
              child: Text('No images found.'),
            );
          }

          return PageView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (context, index) {
              currentFilePath = snapshot.data[index].path;
              var extension = path.extension(snapshot.data[index].path);
              if (extension == '.jpeg') {
                return Container(
                  height: 300,
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Image.file(
                    File(snapshot.data[index].path),
                  ),
                );
              } else {
                return VideoPreview(
                  videoPath: snapshot.data[index].path,
                );
              }
            },
          );
        },
      ),
      //Display playback inside of this container
      Container(
      decoration: BoxDecoration(
        borderRadius: new BorderRadius.circular(30.0),
      color: Colors.black),
      width: SizeConfig.safeBlockHorizontal * 70,
      height: SizeConfig.safeBlockVertical * 55,),
      //Caption and Location. Still needs to open a keyboard and have max characters so no clipping widgets
      Container(
      margin: new EdgeInsets.all(1),
      width: SizeConfig.safeBlockHorizontal * 95,
      child: TextField(
        maxLength: 50,
        decoration: new InputDecoration(
        hintText: 'Add a Caption'
      ),
      ),
      ),
      Container(
      margin: new EdgeInsets.all(1),
      width: SizeConfig.safeBlockHorizontal * 95,
      child: TextField(
        maxLength: 150,
        decoration: new InputDecoration(
        hintText: 'Add a Location'
      ),),
      ),
      //Post button. Needs to add function and then go back to responces once complete
      Container(height: SizeConfig.safeBlockVertical * 4,),
      Container(
      margin: new EdgeInsets.all(1),
      width: SizeConfig.safeBlockHorizontal * 30,
      height: SizeConfig.safeBlockVertical * 5,
      child: Center( 
        child: Text('Post',
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
      
                          )
                        )
                      ]
                    )
        
    
      /* bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 60.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.share),
                onPressed: () => _shareFile(),
              ),
              IconButton(
                icon: Icon(Icons.file_upload),
                onPressed: _deleteFile,
              ),
            ],
          ),
        ),
      ), */
    );
  }

  _shareFile() async {
    var extension = path.extension(currentFilePath);
    await Share.file(
      'image',
      (extension == '.jpeg') ? 'image.jpeg' : '	video.mp4',
      File(currentFilePath).readAsBytesSync(),
      (extension == '.jpeg') ? 'image/jpeg' : '	video/mp4',
    );
  }

  _deleteFile() {
    final dir = Directory(currentFilePath);
    dir.deleteSync(recursive: true);
    print('deleted');
    setState(() {});
  }

  Future<List<FileSystemEntity>> _getAllImages() async {
    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/media';
    final myDir = Directory(dirPath);
    List<FileSystemEntity> _images;
    _images = myDir.listSync(recursive: true, followLinks: false);
    _images.sort((a, b) {
      return b.path.compareTo(a.path);
    });
    return _images;
  }
}