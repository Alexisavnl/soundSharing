import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:da_song/models/userData.dart';
import 'package:da_song/widget/search_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';
import 'createPost.dart';
import 'track.dart';
import 'home.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const account());
}

class account extends StatelessWidget {
  const account({Key? key}) : super(key: key);

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

class ListSearchState extends State<ListSearch> {
  final TextEditingController _textController = TextEditingController();
  List<UserData> users = List.empty();
  List<String> statusUsers = List.empty();
  String query = '';
  final FirebaseAuth auth = FirebaseAuth.instance;
  final User currentUser = FirebaseAuth.instance.currentUser!;
  @override
  Widget build(BuildContext context) => Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(22, 27, 34, 1),
          title: const Text('DaSong.',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
          toolbarTextStyle: GoogleFonts.poppins(),
          titleTextStyle: GoogleFonts.poppins(),
          centerTitle: true,
        ),
        body: Column(
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
        ),
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
        print("avant");
        print(doc["uid"]);
        await FirebaseFirestore.instance
            .collection("users")
            .doc(doc.id)
            .collection("friends")
            .get()
            .then(
          (value) {
            print("vlaeur " + value.docs.length.toString());
            for (var element in value.docs) {
              print(element.id);
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
        //print("avant if");
        if (tempo.length == tempoStatus.length) {
          tempoStatus.add("Ajouter");
        }
        //print("avant tempo");
        tempo.add(UserData(
            uid: doc["uid"],
            username: doc["username"],
            photoUrl: doc["photoUrl"],
            friends: tempoS));

        print("tempo" + tempo.length.toString());
        print("tempoStatus" + tempoStatus.length.toString());
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
      onTap: () {
        print(user.username);
      },
      title: Text(user.username),
      trailing: TextButton(
          child: Text(statusUsers[index]),
          onPressed: () {
            changeListStatus(index);
          }));
}
