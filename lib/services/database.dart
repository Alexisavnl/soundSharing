import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

//DatabaseService récupérer des informations sur l'utilisateur en cours
class DatabaseService {
  final String uid;
  late final FirebaseAuth auth;
  late final User? user;
  DatabaseService(this.uid) {
    auth = FirebaseAuth.instance;
    user = auth.currentUser;
  }

  Future<List<String>> uidFriends() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("friend/$uid");

    DatabaseEvent event = await ref.once();
    List<String> uidFriends = [];
    for (var item in event.snapshot.children) {
      uidFriends.add(item.toString());
    }
    return uidFriends;
  }

  void nameOfFirends(List<String> list) async {
    print(user?.displayName);
  }
}
