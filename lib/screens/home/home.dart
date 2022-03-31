import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:da_song/services/firestore_methods.dart';
import 'package:da_song/screens/comment/comments_screen.dart';
import 'package:da_song/screens/appBarCustom.dart';
import 'package:da_song/utils/deezerPlayer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import '../../services/auth.dart';

// La classe homePost permet l'affichage des postes de ses amis
// Elle récupère toutes les données nécessaire dans firestore de firebase
// Elle fait aussi appèle au fichier deezerPlayer pour lancer les musiques
Future<void> main() async {
  runApp(HomePost());
}

class HomePost extends StatelessWidget {
  final Stream<QuerySnapshot> database =
      FirebaseFirestore.instance.collection('posts').snapshots();
  final AuthService _auth = AuthService();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final User user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    DeezerPlayer audioPlayer = DeezerPlayer();
    return Scaffold(
      appBar: const AppBarCustom(),
      body: Column(
        children: <Widget>[
          Expanded(
              child: StreamBuilder<QuerySnapshot>(
                  stream: database,
                  builder: (
                    BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot,
                  ) {
                    if (snapshot.hasError) {
                      return const Text('Something went wrong.');
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Text('Loading');
                    }

                    final data = snapshot.requireData;
                    return ListView.builder(
                        padding: const EdgeInsets.all(0),
                        itemCount: data.size,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 4,
                                  horizontal: 16,
                                ).copyWith(right: 0),
                                child: Row(
                                  children: <Widget>[
                                    CircleAvatar(
                                      radius: 16,
                                      backgroundImage: NetworkImage(
                                        data.docs[index]["profUrl"].toString(),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          left: 8,
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              data.docs[index]["username"]
                                                  .toString(),
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  audioPlayer.play(
                                      data.docs[index]['preview'].toString());
                                },
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.35,
                                      width: double.infinity,
                                      child: Image.network(
                                        data.docs[index]['pictureBig']
                                            .toString(),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                children: <Widget>[
                                  IconButton(
                                      icon: data.docs[index]['likes']
                                              .contains(user.uid)
                                          ? const Icon(
                                              Icons.favorite,
                                              color: Colors.red,
                                            )
                                          : const Icon(
                                              Icons.favorite_border,
                                            ),
                                      onPressed: () {
                                        FireStoreMethods().likePost(
                                            data.docs[index]['uid'].toString(),
                                            user.uid,
                                            data.docs[index]['likes']);
                                      }),
                                  IconButton(
                                      icon: const Icon(
                                        Icons.comment_outlined,
                                      ),
                                      onPressed: () {
                                        audioPlayer.reset();
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                CommentsScreen(
                                              postId: data.docs[index]['uid']
                                                  .toString(),
                                            ),
                                          ),
                                        );
                                      }),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Artiste: " +
                                            data.docs[index]["artistName"]
                                                .toString(),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        "titre: " +
                                            data.docs[index]["title"]
                                                .toString(),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Expanded(
                                      child: Align(
                                    alignment: Alignment.bottomRight,
                                    child: IconButton(
                                        icon: const Icon(Icons.bookmark_border),
                                        onPressed: () {}),
                                  ))
                                ],
                              )
                            ],
                          );
                        });
                  }))
        ],
      ),
    );
  }
}
