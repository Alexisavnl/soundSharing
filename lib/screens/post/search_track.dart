import 'dart:async';
import 'dart:convert';
import 'package:da_song/screens/appBarCustom.dart';
import 'package:da_song/services/firestore_methods.dart';
import 'package:da_song/utils/deezerPlayer.dart';
import 'package:da_song/widget/search_widget.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../home/home.dart';
import 'createPost.dart';
import 'track.dart';

//Search Track permet d'aller chercher les musiques recherchées par un utilisateur dans la base de
//données deezer grâce l'API.

//fetchTracks lance une requête HTPP à l'API deezer et réçoit réponse sous forme de JSON
//et le transmet à parseTracks
Future<List<Track>> fetchTracks(http.Client client, trackname) async {
  final response = await client.get(Uri.parse(
      'https://api.deezer.com/search/track?q=' +
          trackname +
          '&index=0&limit=100'));
  return compute(parseTracks, response.body);
}

//parseTracks est une fonction qui permet de parser du JSON reçu en paramètres en objet Track et retour la liste des objets
List<Track> parseTracks(String responseBody) {
  final parsed = jsonDecode(responseBody)['data'].cast<Map<String, dynamic>>();
  return parsed.map<Track>((json) => Track.fromJson(json)).toList();
}

Future<void> main() async {
  runApp(SearchTrack());
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

//Affichage de la liste des morceaux correspondant à la recherche de l'utilisateur
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
  FireStoreMethods fireStoreMethods = FireStoreMethods();


  @override
  Widget build(BuildContext context){
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: const AppBarCustom(),
        body: FutureBuilder(
            future: fireStoreMethods.postExist(),
            builder: (BuildContext context, AsyncSnapshot<bool> sharedPreference) {
              print(sharedPreference.data);
              if (sharedPreference.data==true) {
                return const Center(child:Text("Vous avez déjà créé un post aujourd'hui"));
              }
              else {
                return displayList();
              }
            }),
      ),
    );
  }



  Widget displayList(){
   return  Column(
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
      );

  }



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
