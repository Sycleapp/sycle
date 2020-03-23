import 'services.dart';
import 'package:firebase_analytics/firebase_analytics.dart';


/// Static global state. Immutable services that do not care about build context. 
class Global {
  // App Data
  static final String title = 'Sycle';

  // Services
  static final FirebaseAnalytics analytics = FirebaseAnalytics(); 

  //References for FutureBuilder and StremBuilder
  static final Collection topicsFirestore =  Collection(path: 'topics');
}