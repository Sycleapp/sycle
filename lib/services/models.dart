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

class Story { 
  String id;
  String category;
  String title;
  String description;
  String img;
  String date;

  Story({ this.id, this.category, this.title, this.description, this.img});//, this.date });

  factory Story.fromMap(Map data) {
    return Story(
      id: data['id'] ?? '',
      category: data['category'] ?? '',
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      img: data['img'] ?? '',
      //date: data['date'] ?? '2020-01-01'
    );
  }
  
}

//Old Code: Leaving Here for Reference; Should Delete in Future Versions
/* class Topic {
  final String id;
  final String title;
  final String description;
  final String img;
  //final List<Stories> quizzes;

  Topic({ this.id, this.title, this.description, this.img});//, this.quizzes });

  factory Topic.fromMap(Map data) {
    return Topic(
      id: data['id'] ?? 'id',
      title: data['title'] ?? 'title',
      description: data['description'] ?? 'description',
      img: data['img'] ?? 'default.png',
      //quizzes:  (data['quizzes'] as List ?? []).map((v) => Stories.fromMap(v)).toList(), //data['quizzes'],
    );
  }

} */

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

class User {
  final String id;
  final String email;
  final String photoUrl;
  final String displayName;

  User({
    this.id,
    this.email,
    this.photoUrl,
    this.displayName,
  });

  factory User.fromMap(Map doc) {
    return User(
      id: doc['id'],
      email: doc['email'],
      photoUrl: doc['photoUrl'],
      displayName: doc['displayName'],
    );
  }
}



