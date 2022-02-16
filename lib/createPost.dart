import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'track.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:firebase_core/firebase_core.dart';

void main() {
  runApp(const CreatePost());
}

class CreatePost extends StatefulWidget {
  const CreatePost({Key? key}) : super(key: key);

  @override
  _CreatePostState createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  AudioPlayer audioPlayer = AudioPlayer();
  bool isPlaying = false;
  String artist = '';
  String coverMax = '';
  String preview = '';
  String tilte = '';
  CollectionReference posts = FirebaseFirestore.instance.collection('posts');
  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings.arguments as Track;
    artist = arguments.artist.name;
    coverMax = arguments.album.pictureBig;
    preview = arguments.previewUrl;
    tilte = arguments.title;
    initPlayeur(arguments.previewUrl);
    return WillPopScope(
        child: MaterialApp(
          title: "Create post",
          home: Scaffold(
            body: SingleChildScrollView(
              child: Column(children: [
                _cover(arguments.album.pictureBig),
                _soundTitle(arguments.title),
                _albumTitle(arguments.artist.name),
                _btnPlay(audioPlayer, arguments.previewUrl),
                _inputComment(),
                _send(context),
              ]),
            ),
          ),
        ),
        onWillPop: () {
          return _willPopCallback();
        });
  }

  Future<bool> _willPopCallback() async {
    // await showDialog or Show add banners or whatever
    // then
    print('ffd');
    await audioPlayer.stop();
    return Future.value(true);
  }

  initPlayeur(String url) async {
    await audioPlayer.setUrl(url);
  }

  Widget _btnPlay(AudioPlayer audioPlayer, String preview) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: GestureDetector(
        onTap: () {
          setState(() {
            audioPlayer.playing ? audioPlayer.pause() : audioPlayer.play();

            print(audioPlayer.playing);
            isPlaying = audioPlayer.playing;
          });
        },
        child: Icon(
            (audioPlayer.playing ? Icons.pause_circle : Icons.play_circle),
            size: 50.0),
      ),
    );
  }

  Widget _cover(String cover) {
    return Container(
      margin: const EdgeInsets.only(top: 150),
      width: double.infinity,
      alignment: Alignment.center,
      child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.network(
            cover,
            width: 200,
            height: 200,
          )),
    );
  }

  Widget _soundTitle(String title) {
    return Container(
        margin: const EdgeInsets.only(top: 40),
        child: Text(
          title,
          style: GoogleFonts.roboto(
            textStyle: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: Color(0xff000912),
            ),
          ),
        ));
  }

  Widget _albumTitle(String title) {
    return Container(
        margin: const EdgeInsets.only(top: 10),
        child: Text(
          title,
          style: GoogleFonts.roboto(
            textStyle: const TextStyle(
              fontSize: 24,
              color: Color.fromARGB(255, 170, 170, 170),
            ),
          ),
        ));
  }

  Widget _inputComment() {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(50),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            blurRadius: 25,
            offset: Offset(0, 5),
            spreadRadius: -25,
          ),
        ],
      ),
      margin: const EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 40),
      child: TextField(
        style: GoogleFonts.montserrat(
          textStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w400,
            color: Color(0xff000912),
          ),
        ),
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 25, horizontal: 10),
          hintText: "Optional comment: this is the best song ever!!",
          hintStyle: TextStyle(
            color: Color(0xffA6B0BD),
          ),
          fillColor: Colors.white,
          filled: true,
          prefixIconConstraints: BoxConstraints(
            minWidth: 75,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(15),
            ),
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(15),
            ),
            borderSide: BorderSide(color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _send(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: <Color>[
                    Color(0xFF0D47A1),
                    Color(0xFF1976D2),
                    Color(0xFF42A5F5),
                  ],
                ),
              ),
            ),
          ),
          TextButton(
            style: TextButton.styleFrom(
              padding: const EdgeInsets.all(16.0),
              primary: Colors.white,
              textStyle: const TextStyle(fontSize: 20, letterSpacing: 2),
            ),
            onPressed: () {
              audioPlayer.stop();
              posts
                  .add({
                    'artist': artist,
                    'coverMax': coverMax,
                    'preview': preview,
                    'tilte': tilte
                  })
                  .then((value) => print('Post Added'))
                  .catchError((error) => print('Failed to add post: $error'));
              Navigator.pushNamed(context, '/home');
            },
            child: const Text('SEND'),
          ),
        ],
      ),
    );
  }
}
