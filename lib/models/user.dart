import 'package:cloud_firestore/cloud_firestore.dart';

class User{
  final String id;
  final String name;
  final String photoUrl;
  final String email;
  final String timestamp;

  User({
    this.id,
    this.name,
    this.photoUrl,
    this.email,
    this.timestamp,
  });

  factory User.fromDocument(DocumentSnapshot doc){
    return User(
      id: doc ['id'],
      email: doc['email'],
      name: doc['name'],
      photoUrl: doc['photoUrl'],
      timestamp: doc['timestamp']
    );
  }
}