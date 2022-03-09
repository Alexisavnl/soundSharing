import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/userData.dart';

class DatabaseService{
  final String uid;

  DatabaseService(this.uid);

  final CollectionReference<Map<String, dynamic>> userCollection =
  FirebaseFirestore.instance.collection("users");

  Future<void> saveUser(String firstName,String lastName, String email, String profilePicture, String pseudo) async{
    return await userCollection.doc(uid).set({
      'firstName': firstName,
      'lastName': lastName,
      'email':email,
      'profilePicture': profilePicture,
      'pseudo':pseudo
    });
  }

  UserData _userFromSnapshot(DocumentSnapshot<Map<String,dynamic>> snapshot){
    var data = snapshot.data();
    if(data == null) throw Exception("user not found");
    return UserData(
      uid: uid,
      firstName:data['firstName'],
      lastName:data['lastName'],
      email: data['email'],
      profilePicture: data['profilePicture'],
      pseudo: data['pseudo'],
    );
  }
  Stream<UserData> get user{
    return userCollection.doc(uid).snapshots().map(_userFromSnapshot);
  }
  List<UserData> _userListFromSnapshot(QuerySnapshot<Map<String, dynamic>> snapshot) {
    return snapshot.docs.map((doc) {
      return _userFromSnapshot(doc);
    }).toList();
  }

  Stream<List<UserData>> get users {
    return userCollection.snapshots().map(_userListFromSnapshot);
  }

}