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
  String uid;
  String sid;
  String rid;
  String displayName;
  String sTitle;
  String caption;
  String video;
  String location;
  int likeCount;
  List<String> rUsers;

  Reaction({ this.uid, this.sid, this.rid, this.displayName, this.sTitle, this.location, this.video, this.caption, this.likeCount, this.rUsers});

  factory Reaction.fromMap(Map data) {
    return Reaction(
      uid: data['userID'] ?? '',
      sid: data['storyID'] ?? '',
      rid: data['reactionID'] ?? '',
      displayName: data['displayName'] ?? '',
      sTitle: data['storyTitle'] ?? '',
      location: data['location'] ?? 'Mars',
      caption: data['caption'] ?? '',
      video: data['video'] ?? '',
      likeCount: data['likeCount'] ?? 0,
      rUsers: List<String>.from(data['reactionUsers']) ?? ['']
    );
  } 
}

class Feed{
  String rid;
  String uidReaction;
  String rUserName;
  String rUserPhotoUrl;
  String sid;
  String sTitle;
  String uidUpload;
  
  Feed({this.rid, this.uidReaction, this. rUserName, this.rUserPhotoUrl, this.sid, this.sTitle, this.uidUpload});

  factory Feed.fromMap(Map data) {
    return Feed(
      rid: data['reactionID'] ?? '',
      uidReaction: data['reactionUserID'] ?? '',
      rUserName: data['reactionUserName'] ?? '',
      rUserPhotoUrl: data['reactionUserPhotoURL'],
      sid: data['storyID'] ?? '',
      sTitle: data['storyTitle'] ?? '',
      uidUpload: data['uploadUserID'] ?? '',
    );
  } 

}

class Activity{
  String rid;
  String sid;
  String uidUpload;
  int likeCount;
  List<String> rUsers;
  
  Activity({this.rid, this.sid, this.uidUpload, this.likeCount, this.rUsers});

  factory Activity.fromMap(Map data) {
    return Activity(
      rid: data['reactionID'] ?? '',
      sid: data['storyID'] ?? '',
      uidUpload: data['uploadUserID'] ?? '',
      likeCount: data['likeCount'] ?? 0,
      rUsers: List<String>.from(data['reactionUser']) ?? ['']
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



