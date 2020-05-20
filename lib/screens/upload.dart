import 'package:Sycle/shared/size_config.dart';
import 'package:flutter/material.dart';

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
                  Navigator.pop(context);
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
             //Display playback inside of this container
      body: Column(
        children: <Widget>[
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
      GestureDetector(
        onTap: (){Navigator.pushNamed(context, '/reactions');
        },
      child: Container(
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
                      )
                    ]
                  ),
                );
              }
            }