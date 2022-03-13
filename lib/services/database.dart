import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import '../models/userData.dart';

class DatabaseService {
  final String uid;

  DatabaseService(this.uid);

/*
  Future<void> saveUser(String firstName,String lastName, String email, String profilePicture, String pseudo) async{
    return await userCollection.doc(uid).set({
      'firstName': firstName,
      'lastName': lastName,
      'email':email,
      'profilePicture': profilePicture,
      'pseudo':pseudo
    });
  }

 */

  Future<int> uidUser() async {
    /*TransactionResult result =
        await _usersRef.child(uid).runTransaction((Object? useruid) {
      if (useruid != null) {
        return Transaction.abort();
      }
    });
    print('Snapshot? ${result.snapshot}');*/
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? users = auth.currentUser;
    final uid = users?.uid;
    print(uid);
DatabaseReference ref = FirebaseDatabase.instance.ref("friend/$uid");

// Get the data once
DatabaseEvent event = await ref.once();

// Print the data of the snapshot
print(event.snapshot.value);

    return 1;
  }

  /*UserData _userFromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    var data = snapshot.data();
    if (data == null) throw Exception("user not found");
    return UserData(
      //uid: uid,
      firstName: data['firstName'],
      //lastName:data['lastName'],
      //email: data['email'],
      //profilePicture: data['profilePicture'],
      //pseudo: data['pseudo'],
    );
  }

  Stream<UserData> get user {
    return userCollection.doc(uid).snapshots().map(_userFromSnapshot);
  }

  Stream<UserData> friend(String id) {
    return userCollection
        .doc(uid)
        .collection('friend')
        .doc(id)
        .snapshots()
        .map(_userFromSnapshot);
  }

  List<UserData> _userListFromSnapshot(
      QuerySnapshot<Map<String, dynamic>> snapshot) {
    return snapshot.docs.map((doc) {
      return _userFromSnapshot(doc);
    }).toList();
  }

  Stream<List<UserData>> get users {
    return userCollection.snapshots().map(_userListFromSnapshot);
  }

  Stream<List<UserData>> get friends {
    Stream<List<UserData>> list = [] as Stream<List<UserData>>;
    users.forEach((user) {
      friends.forEach((friend) {
        if (user == friend) {
          list.add(user);
        }
      });
    });
    return list;
  }*/
}
