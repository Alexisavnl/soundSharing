import 'package:da_song/screens/edit_profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:da_song/widget/button_widget.dart';
import 'package:da_song/widget/numbers_widget.dart';
import 'package:da_song/widget/profile_widget.dart';
import 'package:da_song/account.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = FirebaseAuth.instance.currentUser!;
    double height = MediaQuery.of(context).size.height - 100;
    return Builder(
      builder: (context) => Scaffold(
        body: ListView(
          children: [
            ProfileWidget(
              user.photoURL!,
              false,
              () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => EditProfilePage()),
                );
              },
            ),
            const SizedBox(height: 24),
            buildName(user),
            const SizedBox(height: 24),
            NumbersWidget(),
            const SizedBox(height: 48),
            const SizedBox(height: 200),
            friendsManager(context),
          ],
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

  Widget friendsManager(BuildContext context) => DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: const TabBar(
            tabs: [
              Tab(
                text: 'Friends',
              ),
              Tab(
                text: 'Search',
              ),
            ],
          ),
          body: TabBarView(
            children: [
              Center(
                child: ElevatedButton(
                  child: const Text('dndd'),
                  onPressed: () async {
                    print("jdjd");
                  },
                ),
              ),
              Center(
                child: ElevatedButton(
                  child: const Text('sign out'),
                  onPressed: () async {
                    print("sss");
                  },
                ),
              )
            ],
          ),
        ),
      );
}
