import 'package:flutter/material.dart';
import 'package:sycle/screens/activity.dart';
import 'package:sycle/screens/profile.dart';

class DiscoverPage extends StatefulWidget {
  @override
  _DiscoverPageState createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                    'https://images.unsplash.com/photo-1517030330234-94c4fb948ebc?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1275&q=80'),
                fit: BoxFit.cover,
              ),
            ),
            child: Center(
              child: Text(
                'Home Layout',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                ),
              ),
            ),
          ),
          Positioned(
            child: AppBar(
              leading: IconButton(
                icon: Icon(Icons.account_circle),
                onPressed: (){
                  Navigator.push(context, new MaterialPageRoute(builder: (context) => ProfileScreen()));
                },
              ),
              title: Text("Discover"),
              backgroundColor: Colors.transparent,
              elevation: 0,
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.notifications),
                  onPressed: () {
                    Navigator.push(context, new MaterialPageRoute(builder: (context) => ActivityScreen()));
                  },
                  tooltip: 'Share',
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}