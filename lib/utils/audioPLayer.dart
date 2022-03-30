
import 'package:just_audio/just_audio.dart';
class AudioPlayer{



  static final AudioPlayer _singleton = AudioPlayer._internal();

  factory AudioPlayer() {
    return _singleton;
  }

  AudioPlayer._internal(){

  }
  void pause(){

  }
}