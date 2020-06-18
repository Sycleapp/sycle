import 'package:Sycle/screens/responses.dart';
import 'package:Sycle/screens/screens.dart';
import 'package:Sycle/shared/scale_route.dart';
import 'package:Sycle/shared/size_config.dart';
import 'package:flutter/material.dart';

class CreateScreen extends StatefulWidget {
  @override
  _CreateScreenState createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  @override
  Widget build(BuildContext context) {
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
              onTap: () => Navigator.pushNamed(context, '/upload'),
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
}