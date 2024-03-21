import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:labhouse_radio_station/features/radio/domain/services/audio_service.dart';

class JustAudioService implements AudioService {
  final _player = AudioPlayer();

  JustAudioService() {
    _player.playerStateStream.listen((playerState) {
      debugPrint('-- Player state: $playerState');
      if (playerState.processingState == ProcessingState.idle && playerState.playing == false) {
        debugPrint('Player has stopped because of an error');
      }
    });
  }

  @override
  Future<void> startPlaying(String url) async {
    try {
      await _player.setUrl(url);
      _player.play();
    } catch (e) {
      debugPrint('-- Error playing audio: $e');
    }
  }

  @override
  void stopPlaying() {
    _player.stop();
  }

  @override
  void dispose() {
    _player.dispose();
  }
}