import 'package:just_audio/just_audio.dart';

class DeezerPlayer {
  static final DeezerPlayer _singleton = DeezerPlayer._internal();

  AudioPlayer audioPlayer = AudioPlayer();
  String lastPreview = "";

  factory DeezerPlayer() {
    return _singleton;
  }

  DeezerPlayer._internal();
  Future<void> play(String preview) async {
    if (audioPlayer.playing && lastPreview.compareTo(preview) == 0) {
      audioPlayer.pause();
      return;
    }
    lastPreview = preview;
    audioPlayer.setUrl(preview);
    await audioPlayer.play();
  }

  void reset() {
    audioPlayer.stop();
    lastPreview = "";
  }
}
