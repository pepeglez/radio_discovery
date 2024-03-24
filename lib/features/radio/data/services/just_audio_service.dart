import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:labhouse_radio_station/features/radio/domain/services/audio_service.dart';

import 'dart:async';



class JustAudioService implements AudioService {
  final _player = AudioPlayer();
  final _audioStatusController = StreamController<AudioStatus>.broadcast();

  @override
  Future<void> startPlaying(String url) async {
    try {
      await _player.setUrl(url);
      _player.play();
    } catch (e) {
      debugPrint('-- Error playing audio: $e');
      _audioStatusController.add(AudioStatus.error);
    }
  }

  @override
  void stopPlaying() {
    _player.stop();
  }

  @override
  void dispose() {
    _player.dispose();
    _audioStatusController.close();
  }

  @override
  Stream<PlayerState> get playerStateStream => _player.playerStateStream;

  Stream<AudioStatus> get audioStatusStream => _audioStatusController.stream;

  JustAudioService() {
    _player.playerStateStream.listen((playerState) {
      if (playerState.playing) {
        _audioStatusController.add(AudioStatus.playing);
        return;
      }

      switch (playerState.processingState) {
        case ProcessingState.completed:
        case ProcessingState.idle:
          _audioStatusController.add(AudioStatus.paused);
          break;
        case ProcessingState.buffering:
        case ProcessingState.loading:
          _audioStatusController.add(AudioStatus.loading);
          break;
        default:
      }
    });
  }
}
