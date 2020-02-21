import 'package:flutter/material.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:sycle/screens/discover.dart';
import 'services/services.dart';
import 'screens/screens.dart';
import 'package:firebase_analytics/firebase_analytics.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
        }
    );
  }
}