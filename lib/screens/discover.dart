import 'package:Sycle/screens/responses.dart';
import 'package:flutter/material.dart';

class DiscoverPage extends StatefulWidget {
  @override
  _DiscoverPageState createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light, 
        iconTheme: IconThemeData(
            color: Colors.black, //change your color here
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

      //Card UI, put this into your card code for the Frontend UI. 
     body: Center(
       child: Card(
         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: new AspectRatio(aspectRatio: 400 / 600,
        //Remove this when you put it into a listview. This is just test code
              child: InkWell(
              onTap: () => Navigator.push(
              context,
                MaterialPageRoute(builder: (context) => ResponseScreen())), 
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
                    new AspectRatio(aspectRatio: 400 / 520),
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