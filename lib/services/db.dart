import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'package:rxdart/rxdart.dart';
import './globals.dart';
import './models.dart';

//Needs to be connected with Firebase (Chase S)

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

  /* Stream<List<Topic>> streamTopicsData() {
    return ref.snapshots().map((list) => list.documents.map((doc) => Topic.fromFirestore(doc)) );
  } */

}


class UserData<T> {
  final Firestore _db = Firestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final String collection;

  UserData({ this.collection });


  Stream<T> get documentStream {

    return Observable(_auth.onAuthStateChanged).switchMap((user) {
      if (user != null) {
          Document<T> doc = Document<T>(path: '$collection/${user.uid}'); 
          return doc.streamData();
      } else {
          return Observable<T>.just(null);
      }
    }); //.shareReplay(maxSize: 1).doOnData((d) => print('777 $d'));// as Stream<T>;
  }

  Stream<T> specificDocumentStream(String userID) {
    Document<T> doc = Document<T>(path: '$collection/$userID'); 
    return doc.streamData();    
  }

  Future<T> getDocument() async {
    FirebaseUser user = await _auth.currentUser();

    if (user != null) {
      Document doc = Document<T>(path: '$collection/${user.uid}'); 
      return doc.getData();
    } else {
      return null;
    }

  }

  Future<void> upsert(Map data) async {
    FirebaseUser user = await _auth.currentUser();
    Document<T> ref = Document(path:  '$collection/${user.uid}');
    return ref.upsert(data);
  }

}

class DataServices{
  final Firestore _db = Firestore.instance;

  //need to change the following fields
   Future<void> updateLikeInformationInFeedSubCollection(DocumentSnapshot reaction, FirebaseUser user, bool isTapped) async{
    String rid = reaction['reactionID'];
    String sid = reaction['storyID'];
    String sTitle = reaction['storyTitle'];
    String uidUploader = reaction['userID'];
    List<String> clickUsers = new List<String>.from(reaction['reactionUsers']);
    String uidClicker = user.uid;
    String clickerName = user.displayName;
    String clickerPhoto = user.photoUrl;

    //check if user has already liked the reaction
    bool isRecorded = false;
    
    if(clickUsers != null){
      clickUsers.forEach((user) => {
        if(user == uidClicker){
          isRecorded = true
        }
      });
    }

    if(isTapped && !isRecorded){
      print("DATA SHOULD BE UPDATED");
      try{
        _db.collection('stories').document(sid).collection('reactions').document(rid).updateData(
          {
            'reactionUsers': FieldValue.arrayUnion([uidClicker]),
            'likeCount': FieldValue.increment(1)
          }
        );
        _db.collection('users').document(uidClicker).collection('feeds').document().setData(
          {
            'reactionUserID': uidClicker,
            'reactionUserName': clickerName.split(" ")[0],
            'reactionUserPhotoURL': clickerPhoto,
            'storyID': sid,
            'storyTitle': sTitle,
            'reactionID': rid,
            'uploadUserID': uidUploader
          }, merge: true
        );
    
        isRecorded = true;
      }
      catch(e){
        print(e.toString());
      }
    }

    if(!isTapped && isRecorded){
      try{
        _db.collection('stories').document(sid).collection('reactions').document(rid).updateData(
          {
            'reactionUsers': FieldValue.arrayRemove([uidClicker]),
            'likeCount': FieldValue.increment(-1)
          }                    
        );
        var query = _db.collection('users').document(uidClicker).collection('feeds').where('reactionID', isEqualTo: rid).where('reactionUserID', isEqualTo: uidClicker);
        query.getDocuments().then((collectionSnapshot) => {
          collectionSnapshot.documents.forEach((doc){
            doc.reference.delete();
          })
        });

        isRecorded = false;
      }
      catch(e){
        print(e.toString());
      }       
    } 
  }

}