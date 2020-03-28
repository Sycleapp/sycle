import 'package:flutter/material.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:sycle/screens/discover.dart';
import 'package:sycle/screens/respond.dart';
import 'services/services.dart';
import 'screens/screens.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:provider/provider.dart';
import 'services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';

//void main() => runApp(MyApp());
void main(){
  print('RUNNING APP');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers:[
        FutureProvider<List<Story>>.value(value: Global.storiesFirestore.getStories()),
        //StreamProvider<FirebaseUser>.value(value: AuthService().user),
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
          '/respond': (context) => Respond(),
        }
      )  
    );
  }
} 
