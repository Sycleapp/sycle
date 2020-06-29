import 'package:flutter/material.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'screens/screens.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'services/services.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          //FutureProvider<List<Story>>.value(value: Global.storiesRef.getData()),
          StreamProvider<FirebaseUser>.value(
              value: FirebaseAuth.instance.onAuthStateChanged),
          FutureProvider<List<Topic>>.value(value: Global.topicRef.getData()),
          //StreamProvider<List<Topic>>.value(value: Global.topicRef.streamData())
          //StreamProvider<Topic>.value(value: Global.entryRef.streamData()),
          //StreamProvider<User>.value(value: Global.userRef.documentStream)    
          //FutureProvider<List<Reaction>>.value(value: Global.reactionsRef.getData()),
        ],
        child: MaterialApp(debugShowCheckedModeBanner: false,
            // Firebase Analytics
            navigatorObservers: [
              FirebaseAnalyticsObserver(analytics: FirebaseAnalytics()),
            ],
            // Named Routes
            routes: {
              '/': (context) => LoginScreen(),
              '/discover': (context) => DiscoverScreen(),
              '/profile': (context) => ProfileScreen(true),
              '/activity': (context) => ActivityScreen(),
              '/responses': (context) => ResponseScreen(),
              //'/upload': (context) => UploadScreen(),
              '/preview': (context) => PreviewScreen(),
              '/explore': (context) => ExploreScreen(),
              //'/create': (context) => CreateScreen(),
            }
        )
    );
  }
}
