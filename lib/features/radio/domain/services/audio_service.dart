abstract class AudioService {
  Future<void> startPlaying(String url);
  void stopPlaying();
  void dispose();
}