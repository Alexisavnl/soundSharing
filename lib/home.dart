import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'createPost.dart';
import 'services/auth.dart';

Future<void> main() async {
  runApp(HomePost());
}

class HomePost extends StatelessWidget {
  final Stream<QuerySnapshot> database =
      FirebaseFirestore.instance.collection('posts').snapshots();
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(22, 27, 34, 1),
        title: const Text('DaSong.',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
        toolbarTextStyle: GoogleFonts.poppins(),
        titleTextStyle: GoogleFonts.poppins(),
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
                          return SizedBox(
                              child: InkWell(
                            child: ListTile(
                              title:
                                  Image.network(data.docs[index]['coverMax']),
                            ),
                            onTap: () async {
                              await _auth.signOut();
                            },
                          )
                              //'My name is ${data.docs[index]['name']}'
                              );
                        });
                  }))
        ],
      ),
    );
  }
}
/**@override
    Widget build(BuildContext context) {
    return MaterialApp(
    title: 'Welcome to Flutter',
    home: Scaffold(
    appBar: AppBar(
    title: const Text('Welcome to Flutter'),
    ),
    body: Padding(
    padding: const EdgeInsets.all(20.0),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Container(
    height: 140,
    width: MediaQuery.of(context).size.height * 1,
    padding: const EdgeInsets.all(20.0),
    child: StreamBuilder<QuerySnapshot>(
    stream: user,
    builder: (
    BuildContext context,
    AsyncSnapshot<QuerySnapshot> snapshot,
    ) {
    if (snapshot.hasError) {
    return const Text('Something went wrong.');
    }
    if (snapshot.connectionState ==
    ConnectionState.waiting) {
    return const Text('Loading');
    }

    final data = snapshot.requireData;

    return ListView.builder(
    padding: const EdgeInsets.all(0),
    itemCount: data.size,
    itemBuilder: (context, index) {
    return SizedBox(
    child: InkWell(
    child: ListTile(
    title:
    Image.network(data.docs[index]['coverMax']),
    ))
    //'My name is ${data.docs[index]['name']}'
    );
    });
    })),
    ],
    ),
    ),
    ),
    );
    }
    }**/

/**itemCount: tracks.length,
    itemBuilder: (BuildContext context, int index) {
    return SizedBox(
    height: 60,
    child: InkWell(
    child: ListTile(
    title: Text(tracks[index].title),
    subtitle: Text(tracks[index].artist.name),
    leading: InkWell(
    child: tracks[index].album.pictureSmall ==
    null
    ? const Text('')
    : Image.network(
    tracks[index].album.pictureSmall),
    onTap: () =>
    playAudio(tracks[index].previewUrl))),
    onTap: () {
    Navigator.pushNamed(context, '/createPost',
    arguments: tracks[index]);
    }));
    }))**/
