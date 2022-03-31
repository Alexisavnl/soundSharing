import 'dart:async';
import 'dart:convert';
import 'package:da_song/screens/appBarCustom.dart';
import 'package:da_song/utils/deezerPlayer.dart';
import 'package:da_song/widget/search_widget.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../home/home.dart';
import 'createPost.dart';
import 'track.dart';

Future<List<Track>> fetchTracks(http.Client client, trackname) async {
  final response = await client.get(Uri.parse(
      'https://api.deezer.com/search/track?q=' +
          trackname +
          '&index=0&limit=100'));
  return compute(parseTracks, response.body);
}

List<Track> parseTracks(String responseBody) {
  final parsed = jsonDecode(responseBody)['data'].cast<Map<String, dynamic>>();
  return parsed.map<Track>((json) => Track.fromJson(json)).toList();
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const SearchTrack());
}

class SearchTrack extends StatelessWidget {
  const SearchTrack({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const Scaffold(body: Center(child: ListSearch())),
      debugShowCheckedModeBanner: false,
      routes: {
        "/createPost": (context) => const CreatePost(),
        '/home': (context) => HomePost(),
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
  DeezerPlayer audioPlayer = DeezerPlayer();
  String query = '';

  @override
  Widget build(BuildContext context) => Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: const AppBarCustom(),
        body: Column(
          children: <Widget>[
            buildSearch(),
            Expanded(
              child: ListView.builder(
                itemCount: tracks.length,
                itemBuilder: (context, index) {
                  final track = tracks[index];
                  return buildTrack(track);
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
        onChanged: searchTracks,
      );

  searchTracks(String value) async {
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

  Widget buildTrack(Track track) => ListTile(
        leading: InkWell(
            child: track.album.pictureSmall == null
                ? const Text('')
                : Image.network(track.album.pictureSmall),
            onTap: () {
              audioPlayer.play(track.previewUrl);
            }),
        title: Text(track.title),
        subtitle: Text(track.artist.name),
        onTap: () {
          Navigator.pushNamed(context, '/createPost', arguments: track);
        },
      );
}
