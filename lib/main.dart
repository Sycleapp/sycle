import 'package:flutter/material.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'services/services.dart';
import 'screens/screens.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  //AuthService auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers:[
        FutureProvider<List<Story>>.value(value: Global.storiesRef.getData()),
        StreamProvider<FirebaseUser>.value(value: FirebaseAuth.instance.onAuthStateChanged)
        //FutureProvider<List<Reaction>>.value(value: Global.reactionsRef.getData()),
      ],
      child: MaterialApp(
        // Firebase Analytics
        navigatorObservers: [
          FirebaseAnalyticsObserver(analytics: FirebaseAnalytics()),
        ],
        // Named Routes
        routes: {
          '/': (context) => LoginScreen(),
          '/discover': (context) => DiscoverPage(),
          '/profile': (context) => ProfileScreen(),
          '/activity': (context) => ActivityScreen(),
          //'/responses': (context) => ResponseScreen(),
          '/camera': (context) => CameraExampleHome(),
        }
      )
    );
  }
}
