import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:da_song/track.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Post {
  final String artistName;
  final String pictureBig;
  final String title;
  final String preview;
  final String description;
  final String uid;
  final String username;
  final likes;
  final DateTime datePublished;
  final String profUrl;

  const Post({
    required this.artistName,
    required this.pictureBig,
    required this.title,
    required this.preview,
    required this.description,
    required this.uid,
    required this.username,
    required this.likes,
    required this.datePublished,
    required this.profUrl,
  });

  static Post fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Post(
        artistName: snapshot["artistName"],
        pictureBig: snapshot["pictureBig"],
        title: snapshot["title"],
        preview: snapshot["preview"],
        description: snapshot["description"],
        uid: snapshot["uid"],
        likes: snapshot["likes"],
        datePublished: snapshot["datePublished"],
        username: snapshot["username"],
        profUrl: snapshot["profUrl"]);
  }

  Map<String, dynamic> toJson() => {
        "artistName": artistName,
        "pictureBig": pictureBig,
        "title": title,
        "preview": preview,
        "description": description,
        "uid": uid,
        "likes": likes,
        "username": username,
        "datePublished": datePublished,
        "profUrl": profUrl,
      };
}
