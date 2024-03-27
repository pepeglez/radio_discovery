import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:radio_discovery/features/radio/domain/services/audio_service.dart';

import 'dart:async';

class JustAudioService implements AudioService {
  final _player = AudioPlayer();
  final _audioStatusController = StreamController<AudioStatus>.broadcast();

  @override
  Future<void> startPlaying(String url) async {
    debugPrint('Playing audio from: $url');
    try {
      await _player.setUrl(url);
      _player.play();
    } catch (e) {
      debugPrint('Error playing audio: $e');

      final newUrl = _checkUrl(url);
      if (newUrl != null) {
        debugPrint('Trying with HTTPS...');
        await startPlaying(newUrl);
        return;
      }

      _audioStatusController.add(AudioStatus.error);
    }
  }

  // check if url is with http or https if tru, returns the usrl with https
  String? _checkUrl(String url) {
    if (url.startsWith('http://')) {
      return url.replaceFirst('http://', 'https://');
    }
    return null;
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

  @override
  Stream<AudioStatus> get audioStatusStream => _audioStatusController.stream;

  JustAudioService() {
    _player.playerStateStream.listen((playerState) {
      if (playerState.playing &&
          playerState.processingState == ProcessingState.ready) {
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
          _audioStatusController.add(AudioStatus.paused);
      }
    });
  }
}
