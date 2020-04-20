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

  //collection class constructor
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

  /*FOR REFERENCE PURPOSES /*Collection Helper Functions that Map Firestore to Class Constructors*/
  //wait for data as a promise; retrieve data one-time only; map individual documents from collection to the Topic class constructor
  Future<List<Story>> getStories() async{
    var storyCollection = await _db.collection('stories').getDocuments(); 
    //list of documents => storyCollection.documents 
    return storyCollection.documents.map((doc) => Story.fromMap(doc.data)).toList();
  }
  
  //get the data collection as a stream;
  Stream<List<Story>> streamStories(){
    //snapshots return a list of documents (do two maps), map individual documents to retrieve data
    return _db.collection('stories').snapshots().map((list) => list.documents.map((doc) => Story.fromMap(doc.data)));
  } */

}

class Database{
  final Firestore _db = Firestore.instance;
  
  //helper function to get reactions subcollections based on storyID
  /* Future<List<Reaction>> getReactionSubCollection(String id) async{
    //var reactionSubCollection = await _db.collectionGroup('reactions').where('storyID', isEqualTo: id).getDocuments();
    var reactionSubCollection = await _db.collection('stories').document(id).collection('reactions').getDocuments();
    return reactionSubCollection.documents.map((doc) => Reaction.fromMap(doc.data)).toList();
  } */

  //BUGGY CODE
 /*  Stream<List<Reaction>> streamReactionSubCollection(String id){
    //var reactionSubCollection = await _db.collectionGroup('reactions').where('storyID', isEqualTo: id).getDocuments();
    var rSubPath = _db.collection('stories').document(id).collection('reactions');
    return rSubPath.snapshots().map((list) => list.documents.map((doc) => Reaction.fromMap(doc.data)));
  } */

  //helper function to get activities subcollections based on userID
  Future<List<Feed>> getFeedSubCollection(String id) async{
    var feedSubCollection = await _db.collection('users').document(id).collection('feeds').getDocuments();
    return feedSubCollection.documents.map((doc) => Feed.fromMap(doc.data)).toList();
  }
  
  //helper function to update information based on like click action; 
  //add/remove data to reaction subcollection, feeds subcollection, and activities collection 
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
