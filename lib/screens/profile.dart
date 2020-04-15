import 'package:flutter/material.dart';
import '../services/services.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatelessWidget {
  final AuthService auth = AuthService();
  
  @override
  Widget build(BuildContext context) {
    FirebaseUser user = Provider.of<FirebaseUser>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        brightness: Brightness.light, 
        iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
        elevation: .2,
        backgroundColor: Colors.white,
         title: Text('Profile',
         style: TextStyle(
           color: Colors.black,
           fontFamily: "Avenir",
          fontWeight: FontWeight.w900,
         ),
        ),
      ),
      body: Center(
        child: Column(
          children:[
            SizedBox(height: 25),
            Image.network(user.photoUrl),
            SizedBox(height: 15), 
            Text(
              user.displayName.split(" ")[0],
              style: TextStyle(
                color: Colors.black,
                fontFamily: "Avenir",
                fontWeight: FontWeight.w600,
                fontSize: 30 
              )
            ),
            SizedBox(height: 50),
            FlatButton(
              child: Text('logout',
                style: TextStyle(
                  color: Colors.white
                ),
              ),
              color: Colors.red,
              onPressed: () async {
                await auth.signOut();
                Navigator.of(context)
                  .pushNamedAndRemoveUntil('/', (route) => false);
              }
            )
          ]
        ),
      ),
    );
  }
}