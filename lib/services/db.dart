import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'package:rxdart/rxdart.dart';
import './globals.dart';
import './models.dart';

class Collection{
  final Firestore _db = Firestore.instance;
  final String path;
  CollectionReference ref;

  //collection class constructor
  Collection({this.path}){
    ref = _db.collection(path);
  }

  /*Collection Helper Functions that Map Firestore to Class Constructors*/
  //wait for data as a promise; retrieve data one-time only; map individual documents from collection to the Topic class constructor
  Future<List<Topic>> getTopics() async{
    var topicCollection = await _db.collection('topics').getDocuments(); 
    //list of documents => topicCollection.documents 
    return topicCollection.documents.map((doc) => Topic.fromMap(doc.data)).toList();
  }
  
  //get the data collection as a stream;
  Stream<List<Topic>> streamTopics(){
    //snapshots return a list of documents (do two maps), map individual documents to retrieve data
    return _db.collection('topics').snapshots().map((list) => list.documents.map((doc) => Topic.fromMap(doc.data)));
  }
}


/* import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'package:rxdart/rxdart.dart';
import './globals.dart';



class Document<T> {
  final Firestore _db = Firestore.instance;
  final String path; 
  DocumentReference ref;

  Document({ this.path }) {
    ref = _db.document(path);
  }

  Future<T> getData() {
    return ref.get().then((v) => Global.models[T](v.data) as T);
  }

  Stream<T> streamData() {
    return ref.snapshots().map((v) => Global.models[T](v.data) as T);
  }

  Future<void> upsert(Map data) {
    return ref.setData(Map<String, dynamic>.from(data), merge: true);
  }

}

class Collection<T> {
  final Firestore _db = Firestore.instance;
  final String path; 
  CollectionReference ref;

  Collection({ this.path }) {
    ref = _db.collection(path);
  }

  Future<List<T>> getData() async {
    var snapshots = await ref.getDocuments();
    return snapshots.documents.map((doc) => Global.models[T](doc.data) as T ).toList();
  }

  Stream<List<T>> streamData() {
    return ref.snapshots().map((list) => list.documents.map((doc) => Global.models[T](doc.data) as T) );
  }

}  */