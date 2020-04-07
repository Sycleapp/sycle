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


class Reaction { 
  //String uid;
  String sid;
  String displayName;
  String caption;
  String video;
  String location;
  //int likes;

  Reaction({ this.sid, this.displayName, this.location, this.video, this.caption});

  factory Reaction.fromMap(Map data) {
    return Reaction(
      //uid: data['userID'] ?? '',
      sid: data['storyID'] ?? '',
      displayName: data['displayName'] ?? '',
      location: data['location'] ?? 'Mars',
      caption: data['caption'] ?? '',
      video: data['video'] ?? '',
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



