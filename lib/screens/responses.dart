//This is the UI for the responces for a story
import 'package:Sycle/screens/screens.dart';
import 'package:flutter/material.dart';

class ResponseScreen extends StatefulWidget {
  @override
  _ResponseScreenState createState() => _ResponseScreenState();
}

class _ResponseScreenState extends State<ResponseScreen> {
  @override
  Widget build(BuildContext context) {
    return Dismissible(
    direction: DismissDirection.vertical,
    key: Key('key'),
    onDismissed: (_) => Navigator.of(context).pop(DiscoverPage),
      child: Container(
      color: Colors.green,
        child: Container(
          
        ),
      )
    );
  }
}