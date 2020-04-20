import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../services/services.dart';

class LoginScreen extends StatefulWidget {
  createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  AuthService auth = AuthService();

  @override
  void initState() {
    super.initState();
    auth.getUser.then(
      (user) {
        if (user != null) {
          //Navigator.pushReplacementNamed(context, '/discover');
          Navigator.pushReplacementNamed(context, '/upload');
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       body: AnnotatedRegion<SystemUiOverlayStyle>(
         value: SystemUiOverlayStyle.light,                
         child: Container(
        padding: new EdgeInsets.all(MediaQuery.of(context).size.width/10),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/logo.png',
            scale: 3,),
            SizedBox(
              height: 30,
            ),
            Text(
              'Welcome to Sycle',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: "avenir",
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.white
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Text('See real prespectives, from real people on todays trending issues.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontFamily: 'avenir',
              fontSize: 20
              ),
            ),
            SizedBox(
              height: 50,
            ),
            LoginButton(
              text: 'LOGIN WITH GOOGLE',
              icon: FontAwesomeIcons.google,
              color: Colors.white,
              loginMethod: auth.googleSignIn,
            ),
          ],
        ),
      ),
      )
    );
  }
}

class LoginButton extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String text;
  final Function loginMethod;

  const LoginButton(
      {Key key, this.text, this.icon, this.color, this.loginMethod})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FlatButton.icon(
        padding: EdgeInsets.all(10),
        icon: Icon(icon, color: const Color(0xFF0037FF)),
        color: color,
        onPressed: () async {
          var user = await loginMethod();
          if (user != null) {
            //Navigator.pushReplacementNamed(context, '/discover');
            Navigator.pushReplacementNamed(context, '/upload');
          }
        },
        label: Expanded(
          child: Text('$text', textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'avenir',
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF0037FF)
          ),
          ),
        ),
        shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0),
                    side: BorderSide(
                      color: Colors.white,
                      width: 3
                      )
        )
      ),
    );
  }
}