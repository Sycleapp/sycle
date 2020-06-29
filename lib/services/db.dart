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

   Future<void> updateLikeInformationInFeedSubCollection(FirebaseUser user, bool isTapped, String responseId, String topicId, String topicName, String uploaderId, List<String>clickedUsers) async{
    String clickerId = user.uid;
    String clickerName = user.displayName;
    String clickerPhoto = user.photoUrl;

    //check if user has already liked the reaction
    bool isRecorded = false;
    
    if(clickedUsers != null){
      clickedUsers.forEach((user) => {
        if(user == clickerId){
          isRecorded = true
        }
      });
    }

    if(isTapped && !isRecorded){
      print("DATA SHOULD BE UPDATED");
      try{
        _db.collection('topics').document(topicId).collection('responses').document(responseId).updateData(
          {
            'responseUsers': FieldValue.arrayUnion([clickerId]),
            'likeCount': FieldValue.increment(1)
          }
        );
        _db.collection('users').document(uploaderId).collection('feeds').document().setData(
          {
            'clickerID': clickerId,
            'clickerName': clickerName.split(" ")[0],
            'clickerPhotoURL': clickerPhoto,
            'topicID': topicId,
            'topicName': topicName,
            'responseID': responseId,
            'uploaderID': uploaderId
          }, merge: true
        );

        _db.collection('users').document(uploaderId).updateData(
          {'totalLikes': FieldValue.increment(1)}
        );
    
        isRecorded = true;
      }
      catch(e){
        print(e.toString());
      }
    }

    if(!isTapped && isRecorded){
      try{
        _db.collection('topics').document(topicId).collection('responses').document(responseId).updateData(
          {
            'responseUsers': FieldValue.arrayRemove([clickerId]),
            'likeCount': FieldValue.increment(-1)
          }
        );
        var query = _db.collection('users').document(uploaderId).collection('feeds').where('responseID', isEqualTo: responseId).where('clickerID', isEqualTo: clickerId);
        query.getDocuments().then((collectionSnapshot) => {
          collectionSnapshot.documents.forEach((doc){
            doc.reference.delete();
          })
        });

         _db.collection('users').document(uploaderId).updateData(
          {'totalLikes': FieldValue.increment(-1)}
        );

        isRecorded = false;
      }
      catch(e){
        print(e.toString());
      }       
    } 
  }

}