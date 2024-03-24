import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:labhouse_radio_station/features/radio/domain/entities/radio_station.dart';
import 'package:labhouse_radio_station/features/radio/domain/services/audio_service.dart';

enum RadioStatus { playing, paused, idle, error, loading }

class RadioPlayerCubit extends Cubit<RadioPlayerState> {
  final AudioService _audioService;

  RadioPlayerCubit(this._audioService)
      : super(const RadioPlayerState());

  Future<void> init() async {
    emit(state.copyWith(radioStatus: RadioStatus.paused));
    _audioService.audioStatusStream.listen(_listenPlayerState);
  }

  void _listenPlayerState(AudioStatus audioStatus) {
    debugPrint('-- Player state: $audioStatus');

    switch (audioStatus) {
      case AudioStatus.playing:
        emit(state.copyWith(radioStatus: RadioStatus.playing));
        return;
      case AudioStatus.loading:
        emit(state.copyWith(radioStatus: RadioStatus.loading));
        return;
      case AudioStatus.paused:
        emit(state.copyWith(radioStatus: RadioStatus.paused));
        return;
      case AudioStatus.error:
        emit(state.copyWith(radioStatus: RadioStatus.error));
        return;
    }
  }

  void playPauseRadioStation(RadioStation station) {
    if (state.radioStatus != RadioStatus.playing ||
        (state.radioStatus == RadioStatus.playing &&
            state.selectedStationId != station.stationUuid)) {
      playRadioStation(station);
    } else {
      stopRadioStation();
    }
  }

  void playRadioStation(RadioStation station) {
    emit(state.copyWith(radioStatus: RadioStatus.loading));
    try {
      _audioService.startPlaying(station.url);
    } catch (e) {
      emit(state.copyWith(radioStatus: RadioStatus.error, selectedStationId: null));
    }

    emit(state.copyWith(
        radioStatus: RadioStatus.playing,
        selectedStationId: station.stationUuid));
  }

  void stopRadioStation() {
    _audioService.stopPlaying();
    emit(state.copyWith(
        radioStatus: RadioStatus.paused, selectedStationId: null));
  }

  @override
  Future<void> close() {
    _audioService.dispose();
    return super.close();
  }
}

class RadioPlayerState extends Equatable {
  final RadioStatus radioStatus;
  final String? selectedStationId;

  const RadioPlayerState({
    this.radioStatus = RadioStatus.idle,
    this.selectedStationId,
  });

  @override
  List<Object?> get props => [radioStatus, selectedStationId];

  RadioPlayerState copyWith({
    RadioStatus? radioStatus,
    String? selectedStationId,
  }) {
    return RadioPlayerState(
      radioStatus: radioStatus ?? this.radioStatus,
      selectedStationId: selectedStationId ?? this.selectedStationId,
    );
  }
}
