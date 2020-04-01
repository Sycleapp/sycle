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



