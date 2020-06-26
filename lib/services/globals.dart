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
    Topic: (data) => Topic.fromMap(data),
    //Topic: (data) => Topic.fromFirestore(data),
    Response: (data) => Response.fromMap(data)
    //Stories: (data) => Stories.fromMap(data),
    //Reactions: (data) => Reactions.fromMap(data),
  };

  // Firestore References for Writes
  //static final Collection<Reactions> topicsRef = Collection<Reactions>(path: 'reactions');
  //static final Collection<Stories> storiesRef = Collection<Stories>(path: 'stories');
  static final UserData<User> userRef = UserData<User>(collection: 'users');
  static final Collection<Topic> topicRef = Collection<Topic>(path: 'topics');
  
  static final Document<Topic> entryRef = Document<Topic>(path: 'topics/rBixUJ3y2R8vu3KBWOxK');  

  
}