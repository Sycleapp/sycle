import 'package:Sycle/screens/screens.dart';
import 'package:Sycle/shared/scale_route.dart';
import 'package:flutter/material.dart';

class DiscoverScreen extends StatefulWidget {
  @override
  _DiscoverScreenState createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
        appBar: AppBar(
        backgroundColor: Colors.black,
        brightness: Brightness.dark, 
        iconTheme: IconThemeData(
            color: Colors.green, //change your color here
          ),
           elevation: .2,
         title: Text('Discover',
         style: TextStyle(
           color: Colors.white,
           fontFamily: "Avenir",
          fontWeight: FontWeight.w900,
         ),
        ),
      ),
      

      //Card UI, put this into your card code for the Frontend UI. 
     body: Center(
       child: Card(
         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: new AspectRatio(aspectRatio: 450 / 700,
        //Remove this when you put it into a listview. This is just test code
              child: InkWell(
              onTap: () => Navigator.push(context, ScaleRoute(page: ResponseScreen())),
              //Testcode ends
              child: Container(
                margin: new EdgeInsets.all(0),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                //Put the images from the listview
                image: DecorationImage(
                  image: AssetImage('assets/images/Card2.png'),
                  fit: BoxFit.cover
                  )
                ), 
                //Text
                child: Column(
                  children: <Widget>[
                    new AspectRatio(aspectRatio: 450 / 620),
                    //Catagory
                    Container(
                      child: new Text(
                      'Catagory',
                      style: new TextStyle(
                      fontFamily: "Avenir",
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  alignment: Alignment(-0.92, .99),
                ),
                Container(
                  //Title
                  child: new Text(
                    'Title of a Topic',
                      style: new TextStyle(
                      fontFamily: "Avenir_Black",
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      fontSize: 33,
                    ),
                  ),
                  alignment: Alignment(-0.85, 0.99),
                )
              ]
            ),
          )
        )
      )
      )
     )    
    );
  }
}