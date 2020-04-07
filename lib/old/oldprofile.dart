/* import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sycle/services/models.dart';
import 'package:sycle/widgets/progress.dart';
import 'package:sycle/screens/home.dart';

class ProfileScreen extends StatefulWidget {
  final String profileId;

  ProfileScreen({this.profileId});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<ProfileScreen> {

  Column buildCountColumn(String label, int count) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          count.toString(),
          style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
        ),
        Container(
          margin: EdgeInsets.only(top: 4.0),
          child: Text(
            label,
            style: TextStyle(
              color: Colors.grey,
              fontSize: 15.0,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }

  buildProfileButton() {
    return Text("profile button");
  }

  buildProfileHeader() {
    return FutureBuilder(
      future: usersRef.document(widget.profileId).get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return circularProgress();
        }
        User user = User.fromDocument(snapshot.data);
        return Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                   SizedBox(
                    height: 30,
                    ),
                  CircleAvatar(
                    radius: 60.0,
                    backgroundColor: Colors.grey,
                    backgroundImage: CachedNetworkImageProvider(user.photoUrl),
                  ),
                ],
              ),
              SizedBox(
              height: 30,
              ),
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(top: 2.0),
                child: Text(
                  user.username,
                  style: TextStyle(
                    fontFamily: "Avenir",
                    fontWeight: FontWeight.w900,
                    fontSize: 30
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
         title: Text('Profile',
         style: TextStyle(
           color: Colors.black,
           fontFamily: "Avenir",
          fontWeight: FontWeight.w900,
         ),
         ),

      ),
      body: ListView(
        children: <Widget>[buildProfileHeader()],
      ),
    );
  }
}
 */