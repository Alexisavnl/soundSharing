import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:da_song/models/post.dart';
import 'package:da_song/track.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FireStoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadPost(Track track, String description, User user) async {
    // asking uid here because we dont want to make extra calls to firebase auth when we can just get from our state management
    String res = "Some error occurred";
    try {
      String uid = user.uid;
      String? username = user.displayName;
      String profUrl = '';
      String artistName = track.artist.name;
      String pictureBig = track.album.pictureBig;
      String title = track.title;
      String preview = track.previewUrl;

      Post post = Post(
        artistName: artistName,
        pictureBig: pictureBig,
        title: title,
        preview: preview,
        description: description,
        uid: uid,
        username: username!,
        likes: [],
        datePublished: DateTime.now(),
        profUrl: profUrl,
      );
      print(post.toJson());
      _firestore.collection('posts').doc(uid).set(post.toJson());
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> likePost(String postId, String uid, List likes) async {
    String res = "Some error occurred";
    try {
      if (likes.contains(uid)) {
        // if the likes list contains the user uid, we need to remove it
        _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        // else we need to add uid to the likes array
        _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

// Post comment
  Future<String> postComment(String postId, String text, String uid,
      String name, String profilePic) async {
    String res = "Some error occurred";
    try {
      if (text.isNotEmpty) {
        // if the likes list contains the user uid, we need to remove it
        String commentId = const Uuid().v1();
        _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          'profilePic': profilePic,
          'name': name,
          'uid': uid,
          'text': text,
          'commentId': commentId,
          'datePublished': DateTime.now(),
        });
        res = 'success';
      } else {
        res = "Please enter text";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  updatePseudo(String newPseudo) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    String res = "Some error occurred";
    try {
      if (newPseudo.isNotEmpty) {
        // if the likes list contains the user uid, we need to remove it
        auth.currentUser!.updateDisplayName(newPseudo);
        await _firestore
            .collection("users")
            .doc(auth.currentUser!.uid)
            .update({'username': newPseudo});
        Fluttertoast.showToast(
          timeInSecForIosWeb: 3,
          msg: "le nouveau pseudo a été enregistrée",
          toastLength: Toast.LENGTH_SHORT,
          textColor: Colors.black,
          fontSize: 16,
          backgroundColor: Colors.grey[200],
        );
        res = 'success';
      } else {
        res = "Please enter text";
      }
    } catch (err) {
      res = err.toString();
    }
  }

  updatePhotoUrl(String newPhoto) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    String res = "Some error occurred";
    try {
      if (newPhoto.isNotEmpty) {
        // if the likes list contains the user uid, we need to remove it
        await auth.currentUser!.updatePhotoURL(newPhoto);
        await _firestore
            .collection("users")
            .doc(auth.currentUser!.uid)
            .update({'photoUrl': newPhoto});
        Fluttertoast.showToast(
          timeInSecForIosWeb: 3,
          msg: "Votre photo de profil a été mise à jour",
          toastLength: Toast.LENGTH_SHORT,
          textColor: Colors.black,
          fontSize: 16,
          backgroundColor: Colors.grey[200],
        );
        res = 'success';
      } else {
        res = "Please enter text";
      }
    } catch (err) {
      res = err.toString();
    }
  }
}
