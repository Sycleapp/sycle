import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sycle/screens/activity.dart';
import 'package:sycle/screens/discover.dart';
import 'package:sycle/screens/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sycle/screens/upload.dart';

import 'create_account.dart';

import 'package:sycle/models/user.dart';

final GoogleSignIn googlesignin = GoogleSignIn();
final userRef = Firestore.instance.collection('users');
final DateTime timestamp = DateTime.now();
User currentUser;

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isAuth = false;
  PageController pageController;
  int pageIndex =0;

  void initState(){
    //Sign in flow
    super.initState();
    pageController = PageController(initialPage: 2);
    googlesignin.onCurrentUserChanged.listen((GoogleSignInAccount account){
      handleSignIn(account);
    }, onError: (err){
      print('Error Signing In $err');
    });
    //Reauthenticated when user opens app
    googlesignin.signInSilently(suppressErrors: false)
    .then((account){
      handleSignIn(account);
    }).catchError((err){
      print('error signing in $err');
    });
  }

  handleSignIn(GoogleSignInAccount account) {
    if (account != null){
        createUserInFirestore();
        setState(() {
          isAuth = true;
        });
      } 
      else{
        setState(() {
          isAuth = false;
        });
      }
  }

  @override
  void dispose(){
    pageController.dispose();
    super.dispose();
    }

  createUserInFirestore() async {
    //Check if user exists in users collection in database according to their ID
    final GoogleSignInAccount user = googlesignin.currentUser;
    DocumentSnapshot doc = await userRef.document(user.id).get();

    if(!doc.exists){ 
    //If user does not exist, we take them to the create account page 
    final name = await Navigator.push(context, MaterialPageRoute(builder: (context) => CreateAccount()));
    //Get username from create account, and use it to make users document in database
    userRef.document(user.id).setData({
      "id":user.id,
      "name":name,
      "photoUrl":user.photoUrl,
      "email":user.email,
      "timestamp": timestamp
    });

    doc = await userRef.document(user.id).get();
    }

    currentUser = User.fromDocument(doc);
    print(currentUser);
    print(currentUser.name);
  }

  login(){
    googlesignin.signIn();
  }

  logout(){
    googlesignin.signOut();
  }

  onPagedChanged(int pageIndex){
    setState(() {
      this.pageIndex = pageIndex;
    });
  }

  Widget buildAuthScreen(){
    return Scaffold(
      body: PageView(
        children: <Widget>[
          DiscoverPage(),
          ActivityScreen(),
          ProfileScreen(profileId: currentUser?.id),
          UploadScreen(currentUser: currentUser),
        ],
        controller: PageController(),
        onPageChanged: onPagedChanged,
      )
    );
  }

  buildUnAuthScreen(){
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF0037FF),
              const Color(0xFF0037FF),
            ]
          )
        ),
        alignment: Alignment.center,
        padding: new EdgeInsets.all(MediaQuery.of(context).size.width/10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/images/logo.png',
            scale: 3,),
            SizedBox( height: 50),
            Text('Welcome to Sycle',
            style: TextStyle(
              fontFamily: "Avenir-black",
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: Colors.white
             ),
            ),
            Text('"Quick Summary"',
            style: TextStyle(
              fontFamily: "Avenir",
              fontSize: 19,
              fontWeight: FontWeight.w100,
              color: Colors.white
             ),
            ),
            SizedBox(
              height: 30,
            ),
            GestureDetector(
              child: Container(
                width: 300,
                height: 40,
                child: FlatButton(
                  onPressed: login,
                  color: Colors.white,
                  shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(18.0),
                    side: BorderSide(
                      color: Colors.white,
                      width: 3
                      )
                    ),
                  child: Text('LOG IN WITH GOOGLE',
                  style: TextStyle(
                    fontSize: 17,
                    color: const Color(0xFF0037FF),
                    fontWeight: FontWeight.bold
                  ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return isAuth ? buildAuthScreen() : buildUnAuthScreen();
  }
}