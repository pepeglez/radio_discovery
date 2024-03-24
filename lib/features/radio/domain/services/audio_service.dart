import 'package:just_audio/just_audio.dart';

enum AudioStatus {
  playing,
  loading,
  paused,
  error,
}

abstract class AudioService {
  Stream<PlayerState> get playerStateStream;
  Stream<AudioStatus> get audioStatusStream;
  Future<void> startPlaying(String url);
  void stopPlaying();
  void dispose();
}
