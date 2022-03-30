import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  final String uid;
  final String username;
  final String photoUrl;
  final List<String> friends;

  UserData({
    required this.uid,
    required this.username,
    required this.photoUrl,
    required this.friends
  });

  static UserData fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return UserData(
      username: snapshot["username"],
      uid: snapshot["uid"],
      photoUrl: snapshot["photoUrl"],
      friends: snapshot["friends"]
    );
  }

  Map<String, dynamic> toJson() => {
        "username": username,
        "uid": uid,
        "photoUrl": photoUrl,
         "friends": friends,
      };
}
