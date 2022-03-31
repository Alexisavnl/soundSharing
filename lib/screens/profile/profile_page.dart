import 'package:da_song/screens/login_page/login_page.dart';
import 'package:da_song/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:da_song/widget/profile_widget.dart';

//ProfilePage permet de visualiser son profile
//Lorqu'on clique sur notre photo on est rediriger sur edit_profile
//Un bouton sign out permet de se déconnecter
class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = FirebaseAuth.instance.currentUser!;
    double height = MediaQuery.of(context).size.height - 100;
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 20),
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(children: [
            ProfileWidget(user.photoURL!,false),
            const SizedBox(height: 24),
            buildName(user),
            const SizedBox(height: 40),
            signOut()
          ]),
        ),
      ),
    );
  }

  Widget buildName(User user) => Column(
        children: [
          Text(
            user.displayName!,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          const SizedBox(height: 4),
          Text(
            user.email!,
            style: const TextStyle(color: Colors.grey),
          )
        ],
      );

  Widget signOut() => ElevatedButton(
        style: ElevatedButton.styleFrom(minimumSize: const Size(50, 40)),
        child: const Text('sign out'),
        onPressed: () async {
          await _auth.signOut();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
          );
        },
      );

}