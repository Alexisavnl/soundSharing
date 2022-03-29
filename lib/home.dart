import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:da_song/models/userData.dart';
import 'package:da_song/resources/firestore_methods.dart';
import 'package:da_song/screens/comments_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'services/auth.dart';
import 'package:just_audio/just_audio.dart';

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
    AudioPlayer audioPlayer = AudioPlayer();
    return Scaffold(
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
          const Padding(padding: EdgeInsets.all(12.0)),
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
                          return Container(
                              child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 4,
                                  horizontal: 16,
                                ).copyWith(right: 0),
                                child: Row(
                                  children: <Widget>[
                                    const CircleAvatar(
                                      radius: 16,
                                      backgroundImage: NetworkImage(
                                          "https://media-exp1.licdn.com/dms/image/C4E03AQE7dJmNS-3rrQ/profile-displayphoto-shrink_100_100/0/1635786869728?e=2147483647&v=beta&t=jmByr-3c_FTM5UIYrn4Ts4Bhqpv9CxmI2znJh9df27Y"),
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
                                              data.docs[index]["artistName"]
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
                                  test();
                                  audioPlayer.setUrl(
                                      data.docs[index]['preview'].toString());

                                  if(audioPlayer.playing){
                                    audioPlayer.pause();
                                    audioPlayer.currentIndex;
                                  }else{
                                    audioPlayer.play();
                                  }
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
                                            
                                        _auth.signOut();
                                      }),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.comment_outlined,
                                    ),
                                    onPressed: () => Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => CommentsScreen(
                                          postId: data.docs[index]['uid']
                                              .toString(),
                                        ),
                                      ),
                                    ),
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
                          ));
                        });
                  }))
        ],
      ),
    );
  }

  test() async {
    List<UserData> f = [];
    return FirebaseFirestore.instance
        .collection('users/' + user.uid + "/friends")
        .where("status", isEqualTo: "ami")
        .get()
        .then((value) => {
              value.docs.forEach((element) async {
                await FirebaseFirestore.instance
                    .collection("users/")
                    .doc(element.id)
                    .get()
                    .then((value) => {
                          f.add(UserData(
                              uid: value.data()!['uid'],
                              username: value.data()!['username'],
                              photoUrl: value.data()!['photoUrl'],
                              friends: [])),
                                  print(f.length)
                        });
              }),
            });
    print(f.length);
  }
}
