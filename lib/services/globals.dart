import 'services.dart';
import 'package:firebase_analytics/firebase_analytics.dart';


/// Static global state. Immutable services that do not care about build context. 
class Global {
  // App Data
  static final String title = 'Sycle';

  // Services
  static final FirebaseAnalytics analytics = FirebaseAnalytics();

    // Data Models
  static final Map models = {
    User: (data) => User.fromMap(data),
    Story: (data) => Story.fromMap(data),
    Reaction: (data) => Reaction.fromMap(data),
  };

  // Firestore References for Writes
  //static final Collection<Reaction> reactionsRef = Collection<Reaction>(path: 'reactions');
  static final Collection<Story> storiesRef = Collection<Story>(path: 'stories');
  
}
