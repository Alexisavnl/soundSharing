import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:da_song/models/userData.dart';
import 'package:da_song/screens/profile/profile_page.dart';
import 'package:da_song/widget/search_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const Account());
}

class Account extends StatelessWidget {
  const Account({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(body: Center(child: ListSearch())),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ListSearch extends StatefulWidget {
  const ListSearch({Key? key}) : super(key: key);

  @override
  ListSearchState createState() => ListSearchState();
}

class ListSearchState extends State<ListSearch>
    with SingleTickerProviderStateMixin {
  final TextEditingController _textController = TextEditingController();
  late TabController _controller;
  int _selectedIndex = 0;
  List<UserData> users = List.empty();
  List<UserData> friends = [];
  List<String> statusUsers = List.empty();
  String query = '';
  final FirebaseAuth auth = FirebaseAuth.instance;
  final User currentUser = FirebaseAuth.instance.currentUser!;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 2, vsync: this, initialIndex: 0);
    _controller.addListener(() {
      setState(() {
        _selectedIndex = _controller.index;
      });
    });
    getFriends();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(22, 27, 34, 1),
          title: const Text('DaSong.',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
          toolbarTextStyle: GoogleFonts.poppins(),
          titleTextStyle: GoogleFonts.poppins(),
          centerTitle: true,
          actions: <Widget>[
            GestureDetector(
              onTap: () {
                Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProfilePage()),
                      );
              },
              
              child: CircleAvatar(
                radius: 30.0,
                backgroundImage: NetworkImage(currentUser.photoURL!),
                backgroundColor: Colors.transparent,
              ),
            ),
          ],
          bottom: TabBar(
            onTap: (value) {
              if (value == 0) {
                setState(() {
                  getFriends();
                });
              }
              _onItemTapped(value);
            },
            controller: _controller,
            tabs: const [
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
          controller: _controller,
          children: <Widget>[displayFriends(), displayUser()],
        ),
      ),
    );
  }

  Widget displayFriends() => Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: friends.length,
              itemBuilder: (context, index) {
                final user = friends[index];
                return ListTile(
                  leading: SizedBox(
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(user.photoUrl),
                      radius: 16,
                    ),
                  ),
                  onTap: () {},
                  title: Text(user.username),
                  trailing: TextButton(
                    child: const Text("Supprimer"),
                    onPressed: () async {
                      await FirebaseFirestore.instance
                          .collection("users")
                          .doc(currentUser.uid)
                          .collection("friends")
                          .doc(user.uid)
                          .delete();
                      await FirebaseFirestore.instance
                          .collection("users")
                          .doc(user.uid)
                          .collection("friends")
                          .doc(currentUser.uid)
                          .delete();
                      setState(() {
                        friends.removeAt(index);
                      });
                    },
                  ),
                );
              },
            ),
          ),
        ],
      );

  getFriends() async {
    List<UserData> l = [];
    await FirebaseFirestore.instance
        .collection('users/' + currentUser.uid + "/friends")
        .where("status", isEqualTo: "ami")
        .get()
        .then((QuerySnapshot value) => {
              value.docs.forEach((element) async {
                await FirebaseFirestore.instance
                    .collection("users/")
                    .doc(element.id)
                    .get()
                    .then((value) => {
                          l.add(UserData(
                              uid: value.data()!['uid'],
                              username: value.data()!['username'],
                              photoUrl: value.data()!['photoUrl'],
                              friends: [])),
                          setState(() {
                            friends = l;
                          })
                        });
              }),
            });
    setState(() {
      friends = l;
    });
  }

  Widget displayUser() => Column(
        children: <Widget>[
          buildSearch(),
          Expanded(
            child: ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                final status = statusUsers[index];
                return buildTrack(user, index);
              },
            ),
          ),
        ],
      );

  Widget buildSearch() => SearchWidget(
        textEditingController: _textController,
        text: query,
        hintText: 'Search Here...',
        onChanged: searchUsers,
      );

  searchUsers(String value) async {
    if (value.isEmpty) {
      setState(() {
        users = List.empty();
        statusUsers = List.empty();
      });
      return;
    }
    List<UserData> tempo = [];
    List<String> tempoS = [];
    List<String> tempoStatus = [];
    await FirebaseFirestore.instance
        .collection('users')
        .where('username', isGreaterThanOrEqualTo: value)
        .get()
        .then((QuerySnapshot querySnapshot) async {
      querySnapshot.docs.forEach((doc) async {
        await FirebaseFirestore.instance
            .collection("users")
            .doc(doc.id)
            .collection("friends")
            .get()
            .then(
          (value) {
            for (var element in value.docs) {
              if (element.id == currentUser.uid) {
                switch (element.data()['status']) {
                  case "demande recu":
                    tempoStatus.add("En attentes");
                    break;
                  case "demande envoye":
                    tempoStatus.add("Accepter");
                    break;
                  case "ami":
                    tempoStatus.add("Supprimer");
                }
              }
            }
          },
        );
        if (tempo.length == tempoStatus.length) {
          tempoStatus.add("Ajouter");
        }
        tempo.add(UserData(
            uid: doc["uid"],
            username: doc["username"],
            photoUrl: doc["photoUrl"],
            friends: tempoS));
        setState(() {
          users = tempo;
          statusUsers = tempoStatus;
        });
      });
    });
  }

  changeListStatus(int index) async {
    switch (statusUsers[index]) {
      case "Supprimer":
        await FirebaseFirestore.instance
            .collection("users")
            .doc(currentUser.uid)
            .collection("friends")
            .doc(users[index].uid)
            .delete();
        await FirebaseFirestore.instance
            .collection("users")
            .doc(users[index].uid)
            .collection("friends")
            .doc(currentUser.uid)
            .delete();
        setState(() {
          statusUsers[index] = "Ajouter";
        });
        break;
      case "Ajouter":
        await FirebaseFirestore.instance
            .collection("users")
            .doc(currentUser.uid)
            .collection("friends")
            .doc(users[index].uid)
            .set({"status": "demande envoye"});
        await FirebaseFirestore.instance
            .collection("users")
            .doc(users[index].uid)
            .collection("friends")
            .doc(currentUser.uid)
            .set({"status": "demande recu"});
        setState(() {
          statusUsers[index] = "En attentes";
        });
        break;
      case "Accepter":
        await FirebaseFirestore.instance
            .collection("users")
            .doc(currentUser.uid)
            .collection("friends")
            .doc(users[index].uid)
            .update({"status": "ami"});
        await FirebaseFirestore.instance
            .collection("users")
            .doc(users[index].uid)
            .collection("friends")
            .doc(currentUser.uid)
            .update({"status": "ami"});

        setState(() {
          getFriends();
          statusUsers[index] = "Supprimer";
        });
        break;
      case "En attentes":
        await FirebaseFirestore.instance
            .collection("users")
            .doc(currentUser.uid)
            .collection("friends")
            .doc(users[index].uid)
            .delete();
        await FirebaseFirestore.instance
            .collection("users")
            .doc(users[index].uid)
            .collection("friends")
            .doc(currentUser.uid)
            .delete();
        setState(() {
          statusUsers[index] = "Ajouter";
        });
        break;
    }
  }

  Widget buildTrack(UserData user, int index) => ListTile(
      leading: SizedBox(
        child: CircleAvatar(
          backgroundImage: NetworkImage(user.photoUrl),
          radius: 16,
        ),
      ),
      onTap: () {},
      title: Text(user.username),
      trailing: TextButton(
          child: Text(statusUsers[index]),
          onPressed: () {
            changeListStatus(index);
          }));
}