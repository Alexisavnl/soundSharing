import 'package:just_audio/just_audio.dart';

//Audio player pour lancer une musique grâce à la bibliothèque just_audio
class DeezerPlayer {
  static final DeezerPlayer _singleton = DeezerPlayer._internal();

  AudioPlayer audioPlayer = AudioPlayer();
  String lastPreview = "";

  factory DeezerPlayer() {
    return _singleton;
  }

  DeezerPlayer._internal();

  //Joue ou mets en pause un sons
  Future<void> play(String preview) async {
    if (audioPlayer.playing && lastPreview.compareTo(preview) == 0) {
      audioPlayer.pause();
      return;
    }
    lastPreview = preview;
    audioPlayer.setUrl(preview);
    await audioPlayer.play();
  }

  //Arrêt un sons et remets à null lastPreview
  void reset() {
    audioPlayer.stop();
    lastPreview = "";
  }
}
