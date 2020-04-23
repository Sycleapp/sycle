import 'package:flutter/material.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'screens/screens.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, 
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
          '/responces': (context) => ResponseScreen(),
          '/camera': (context) => CameraScreen(),
        }
    );
  }
}