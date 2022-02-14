import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';
import 'createPost.dart';
import 'track.dart';
import 'home.dart';

Future<List<Track>> fetchTracks(http.Client client, trackname) async {
  final response = await client
      .get(Uri.parse('https://api.deezer.com/search/track?q=' + trackname));
  // Use the compute function to run parsePhotos in a separate isolate.
  //print(response.body);
  return compute(parseTracks, response.body);
}

// A function that converts a response body into a List<Photo>.
List<Track> parseTracks(String responseBody) {
  final parsed = jsonDecode(responseBody)['data'].cast<Map<String, dynamic>>();
  return parsed.map<Track>((json) => Track.fromJson(json)).toList();
}

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(title: const Text('Alexis >>> Martin')),
          body: Center(child: ListSearch())),
      routes: {
        "/createPost": (context) => CreatePost(),
        '/home': (context) => const Home(),
      },
    );
  }
}

class ListSearch extends StatefulWidget {
  ListSearchState createState() => ListSearchState();
}

class ListSearchState extends State<ListSearch> {
  TextEditingController _textController = TextEditingController();
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
                    return Container(
                        height: 60,
                        child: InkWell(
                            child: ListTile(
                                title: Text(tracks[index].title),
                                subtitle: Text(tracks[index].artist.name),
                                leading: InkWell(
                                    child: tracks[index].album.pictureSmall ==
                                            null
                                        ? Text('')
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

class TracksList extends StatelessWidget {
  const TracksList({Key? key, required this.tracks}) : super(key: key);

  final List<Track> tracks;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        padding: const EdgeInsets.all(0),
        itemCount: tracks.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            height: 60,
            child: ListTile(
                title: Text(tracks[index].title),
                subtitle: Text(tracks[index].artist.name),
                leading: Image.network(tracks[index].album.pictureSmall)),
          );
        });
  }
}
