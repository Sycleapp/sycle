/* import 'package:flutter/material.dart';

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
          Navigator.pushReplacementNamed(context, '/topics');
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
      margin: EdgeInsets.only(bottom: 10),
      child: FlatButton.icon(
        shape: new RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(18.0),
        side: BorderSide(
        color: Colors.white,
        width: 3)
        ),
        padding: EdgeInsets.all(30),
        icon: Icon(icon, color: Colors.white),
        color: color,
        onPressed: () async {
          var user = await loginMethod();
          if (user != null) {
            Navigator.pushReplacementNamed(context, '/topics');
          }
        },
        label: Expanded(
          child: Text('$text', textAlign: TextAlign.center),
        ),
      ),
    );
  }
}  */