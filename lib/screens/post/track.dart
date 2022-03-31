//Objet Artist
//Un artiste possède un identifiant et un nom
class Artist {
  final int artistId;
  final String name;

  const Artist({
    required this.artistId,
    required this.name,
  });

  // permet de transformer le JSON en String
  factory Artist.fromJson(Map<String, dynamic> json) {
    return Artist(
      artistId: json['id'] as int,
      name: json['name'] as String,
    );
  }
}

//Objet Album
//Un Album possède une pochette de taille petite, une moyenne et une grande
class Album {
  final String pictureSmall;
  final String pictureMedium;
  final String pictureBig;

  const Album({
    required this.pictureSmall,
    required this.pictureMedium,
    required this.pictureBig,
  });
  // permet de transformer le JSON en String
  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      pictureSmall: json['cover_small'] as String,
      pictureMedium: json['cover_medium'] as String,
      pictureBig: json['cover_big'] as String,
    );
  }
}

//Objet track
//Un track possède un identifiant, un titre, une preview mp3, un Artiste et un Album.
class Track {
  final int trackId;
  final String title;
  final String previewUrl;
  final Artist artist;
  final Album album;

  const Track({
    required this.trackId,
    required this.title,
    required this.previewUrl,
    required this.artist,
    required this.album,
  });

  // permet de transformer le JSON en String
  factory Track.fromJson(Map<String, dynamic> json) {
    return Track(
      trackId: json['id'] as int,
      title: json['title'] as String,
      previewUrl: json['preview'] as String,
      artist: Artist.fromJson(json['artist']),
      album: Album.fromJson(json['album']),
    );
  }
}
