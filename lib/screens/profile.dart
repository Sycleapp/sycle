import 'dart:io';

import 'package:flutter/material.dart';
import '../services/services.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProfileScreen extends StatelessWidget {
  final AuthService auth = AuthService();

  @override
  Widget build(BuildContext context) {
    FirebaseUser user = Provider.of<FirebaseUser>(context);
    User u = Provider.of<User>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        brightness: Brightness.dark,
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        elevation: .2,
        backgroundColor: Colors.white,
        title: Text(
          'Profile',
          style: TextStyle(
            color: Colors.black,
            fontFamily: "Avenir",
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      body: Center(
        child: Column(children: [
          SizedBox(height: 25),
          CircleAvatar(
              radius: 50, backgroundImage: NetworkImage(u.photoUrl)),
          SizedBox(height: 15),
          Text(u.displayName.split(" ")[0],
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: "Avenir",
                  fontWeight: FontWeight.w800,
                  fontSize: 30)),
          Text("${u.totalLikes.toString()} Likes",
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: "Avenir",
                  fontWeight: FontWeight.w800,
                  fontSize: 30)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            BuildSocialMediaLinks('instagram', 'https://www.instagram.com/'),
            BuildSocialMediaLinks('snapchat', 'https://www.snapchat.com/'),
            BuildSocialMediaLinks('youtube', 'https://www.youtube.com/'),
            BuildSocialMediaLinks('twitter', 'https://twitter.com/explore')
          ]),
          SizedBox(height: 15),
          FlatButton(
              child: Text(
                'logout',
                style: TextStyle(color: Colors.white),
              ),
              color: Colors.red,
              onPressed: () async {
                await auth.signOut();
                Navigator.of(context)
                    .pushNamedAndRemoveUntil('/', (route) => false);
              })
        ]),
      ),
    );
  }
}

class BuildSocialMediaLinks extends StatelessWidget {
  final String iconData;
  final String loadUrl;

  BuildSocialMediaLinks(this.iconData, this.loadUrl);

  @override
  Widget build(BuildContext context) {
    var socialMedia = iconData;
    var icon;
    switch (socialMedia) {
      case 'instagram':
        icon = FontAwesomeIcons.instagram;
        break;
      case 'twitter':
        icon = FontAwesomeIcons.twitter;
        break;
      case 'snapchat':
        icon = FontAwesomeIcons.snapchatGhost;
        break;
      case 'youtube':
        icon = FontAwesomeIcons.youtube;
        break;
      default:
        icon = FontAwesomeIcons.facebookSquare;
    }

    return IconButton(
        icon: FaIcon(icon),
        iconSize: 32.0,
        onPressed: () => _loadUrlInBrowser(loadUrl));
  }
}

_loadUrlInBrowser(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not open $url';
  }
}
