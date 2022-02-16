import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';
import 'createPost.dart';
import 'track.dart';
import 'home.dart';

Future<List<Track>> fetchTracks(http.Client client, trackname) async {
  final response = await client.get(Uri.parse(
      'https://api.deezer.com/search/track?q=' +
          trackname +
          '&index=0&limit=100'));
  // Use the compute function to run parsePhotos in a separate isolate.
  return compute(parseTracks, response.body);
}

List<Track> parseTracks(String responseBody) {
  final parsed = jsonDecode(responseBody)['data'].cast<Map<String, dynamic>>();
  return parsed.map<Track>((json) => Track.fromJson(json)).toList();
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(title: const Text('Alexis >>> Martin')),
          body: const Center(child: ListSearch())),
      routes: {
        "/createPost": (context) => const CreatePost(),
        '/home': (context) => Home(),
      },
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
  List<Track> tracks = List.empty();
  AudioPlayer audioPlayer = AudioPlayer();

  onItemChanged(String value) async {
    if (value.isEmpty) {
      setState(() {
        tracks = List.empty();
      });
      return;
    }
    List<Track> tempo = await fetchTracks(http.Client(), value);
    setState(() {
      tracks = tempo;
    });
  }

  playAudio(String preview) async {
    if (audioPlayer.playing) {
      audioPlayer.stop();
    }
    await audioPlayer.setUrl(preview);
    audioPlayer.play();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _textController,
              decoration: const InputDecoration(
                hintText: 'Search Here...',
              ),
              onChanged: onItemChanged,
            ),
          ),
          Expanded(
              child: ListView.builder(
                  padding: const EdgeInsets.all(0),
                  itemCount: tracks.length,
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
                  }))
        ],
      ),
    );
  }
}
