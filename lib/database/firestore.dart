/*

this is for storing posts in firestore

each post will have the following fields:
- user email 
- post content
- timestamp

*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreDatabase {
  // current user
  User? user = FirebaseAuth.instance.currentUser;

  // get posts collection
  final CollectionReference posts =
      FirebaseFirestore.instance.collection('Posts');

  // add post
  Future<void> addPost(String message) {
    return posts.add(
      {
        'UserEmail': user!.email,
        'PostMessage': message,
        'Timestamp': Timestamp.now(),
      },
    );
  }

  // read posts from firestore
  Stream<QuerySnapshot> getPostsStream() {
    final postsStream = FirebaseFirestore.instance
      .collection('Posts')
      .orderBy('Timestamp', descending: true)
      .snapshots();

    return postsStream;
  }
}
