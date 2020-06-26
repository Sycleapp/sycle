import 'package:cloud_firestore/cloud_firestore.dart';

//// Embedded Maps

class Option {
  String value;
  String detail;
  bool correct;

  Option({ this.correct, this.value, this.detail });
  Option.fromMap(Map data) {
    value = data['value'];
    detail = data['detail'] ?? '';
    correct = data['correct'];
  }
}


class Question {
  String text;
  List<Option> options;
  Question({ this.options, this.text });

  Question.fromMap(Map data) {
    text = data['text'] ?? '';
    options = (data['options'] as List ?? []).map((v) => Option.fromMap(v)).toList();
  }
}

///// Database Collections
//OLD/DEPRECTAED CODE
class Stories { 
  String id;
  String title;
  String description;
  String video;
  String topic;
  List<Stories> stories;

  Stories({ this.title, this.stories, this.video, this.description, this.id, this.topic });

  factory Stories.fromMap(Map data) {
    return Stories(
      id: data['id'] ?? '',
      title: data['title'] ?? '',
      topic: data['topic'] ?? '',
      description: data['description'] ?? '',
      video: data['video'] ?? '',
      stories: (data['stories'] as List ?? []).map((v) => Stories.fromMap(v)).toList()
    );
  }
  
}


class Reactions { 
  String id;
  String displayName;
  String caption;
  String video;
  String tag;
  List<Reactions> reactions;

  Reactions({ this.displayName, this.reactions, this.video, this.caption, this.id, this.tag });

  factory Reactions.fromMap(Map data) {
    return Reactions(
      id: data['id'] ?? '',
      displayName: data['displayName'] ?? '',
      tag: data['tag'] ?? '',
      caption: data['caption'] ?? '',
      video: data['video'] ?? '',
      reactions: (data['reactions'] as List ?? []).map((v) => Reactions.fromMap(v)).toList()
    );
  }
  
}

/////

class Topic { 
  String id;
  String title;
  //List<Response> responses;
  
  Topic({this.id, this.title});//, //this.responses});

  factory Topic.fromMap(Map data) {
    return Topic(
      id: data['topicID'] ?? '',
      title: data['topicName'] ?? '',
      //responses: new List<Response>.from(data['responses'])
    );
  }

  /* factory Topic.fromFirestore(DocumentSnapshot doc){
    Map data = doc.data;
    return Topic(
      id: data['topicID'] ?? '',
      title: data['topicName'] ?? '',
    );
  } */
  
}

class Response { 
  String uid;
  String tid;
  String rid;
  String displayName;
  String tTitle;
  String caption;
  String content;
  String location;
  //int likeCount;
  List<String> rUsers;

  Response({ this.uid, this.tid, this.rid, this.displayName, this.tTitle, this.caption, this.content, this.location, this.rUsers});

  factory Response.fromMap(Map data) {
    return Response(
      uid: data['uploaderID'] ?? '',
      tid: data['topicID'] ?? '',
      rid: data['responseID'] ?? '',
      displayName: data['uploaderName'] ?? '',
      tTitle: data['topicName'] ?? '',
      location: data['location'] ?? 'Mars',
      caption: data['caption'] ?? '',
      content: data['responseContent'] ?? '',
      //likeCount: data['likeCount'] ?? 0,
      rUsers: List<String>.from(data['responseUsers']) ?? ['']
    );
  } 
}


class User {
  final String id;
  final String email;
  final String photoUrl;
  final String displayName;
  final int totalLikes;

  User({
    this.id,
    this.email,
    this.photoUrl,
    this.displayName,
    this.totalLikes
  });

  factory User.fromMap(Map doc) {
    return User(
      id: doc['id'],
      email: doc['email'],
      photoUrl: doc['photoUrl'],
      displayName: doc['displayName'],
      totalLikes: doc['totalLikes']
    );
  }

  factory User.initialData(){
    return User(
      id: '',
      email: 'name@example.com',
      photoUrl: 'https://uploads0.wikiart.org/00129/images/katsushika-hokusai/the-great-wave-off-kanagawa.jpg',
      displayName: 'Hello',
      totalLikes: 54321
    );
  }
}



