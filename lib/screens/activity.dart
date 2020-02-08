import 'package:flutter/material.dart';
import 'package:sycle/screens/discover.dart';

class ActivityScreen extends StatefulWidget {
  @override
  _ActivityScreenState createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: (){
                  Navigator.pop(context, new MaterialPageRoute(builder: (context) => DiscoverPage ()));
                },
              ),
        title: Text('Profile'),
      ),
    );
  }
}