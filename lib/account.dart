
import 'package:da_song/list_friends.dart';
import 'package:da_song/models/myUser.dart';
import 'package:da_song/models/userData.dart';
import 'package:da_song/services/database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../services/auth.dart';
import 'package:da_song/screens/login_page/login_page.dart';

class Account extends StatelessWidget {
  Account({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'home',
      home: MyStatefulWidget(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    final String user = _auth.user.toString();
    return DefaultTabController(
      length: 2,
      child: StreamProvider<List<UserData>>.value(
          value: DatabaseService(uid).friends,
          initialData: [],
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: const Color.fromRGBO(22, 27, 34, 1),
              title: const Text('DaSong.',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
              toolbarTextStyle: GoogleFonts.poppins(),
              titleTextStyle: GoogleFonts.poppins(),
              bottom: const TabBar(
                tabs: [
                  Tab(
                    text: 'Friends',
                  ),
                  Tab(
                    text: 'Search',
                  ),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                const Center(
                  child: ListFriends()
                ),
                Center(
                  child: ElevatedButton(
                    child: const Text('sign out'),
                    onPressed: () async {
                      await _auth.signOut();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()),
                      );
                    },
                  ),
                )
              ],
            ),
          )),
    );
  }
}
