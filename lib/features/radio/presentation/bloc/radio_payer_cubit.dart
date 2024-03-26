import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:radio_discovery/features/radio/data/repositories/radio_station_repository_impl.dart';
import 'package:radio_discovery/features/radio/domain/entities/radio_station.dart';
import 'package:radio_discovery/features/radio/domain/services/audio_service.dart';

enum RadioStatus { playing, paused, idle, error, loading }

class RadioPlayerCubit extends Cubit<RadioPlayerState> {
  final AudioService _audioService;
  final RadioStationRepository _radioStationRepository;

  RadioPlayerCubit(this._audioService, this._radioStationRepository)
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
    emit(state.copyWith(selectedStation: station));
    if (state.radioStatus != RadioStatus.playing ||
        (state.radioStatus == RadioStatus.playing &&
            state.selectedStationId != station.stationUuid)) {
      _playRadioStation(station);
    } else {
      _stopRadioStation();
    }
  }

  void _playRadioStation(RadioStation station) async {
    bool isFavorite = await _radioStationRepository.isFavorite(station);

    emit(state.copyWith(radioStatus: RadioStatus.loading));
    try {
      _audioService.startPlaying(station.resolvedUrl);
    } catch (e) {
      emit(state.copyWith(
          radioStatus: RadioStatus.error, selectedStationId: null));
    }

    emit(state.copyWith(
        radioStatus: RadioStatus.playing,
        selectedStationId: station.stationUuid,
        isFavorite: isFavorite));

    _radioStationRepository.addRecentStation(station);
  }

  void _stopRadioStation() {
    _audioService.stopPlaying();
    emit(state.copyWith(
        radioStatus: RadioStatus.paused, selectedStationId: null));
  }

  void toggleFavorite(RadioStation station) {
    _radioStationRepository.toggleFavoriteRadioStation(station);
    emit(state.copyWith(isFavorite: !state.isFavorite));
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
  final RadioStation? selectedStation;
  final bool isFavorite;

  const RadioPlayerState({
    this.radioStatus = RadioStatus.idle,
    this.selectedStationId,
    this.selectedStation,
    this.isFavorite = false,
  });

  @override
  List<Object?> get props =>
      [radioStatus, selectedStationId, selectedStation, isFavorite];

  RadioPlayerState copyWith({
    RadioStatus? radioStatus,
    String? selectedStationId,
    RadioStation? selectedStation,
    bool? isFavorite,
  }) {
    return RadioPlayerState(
      radioStatus: radioStatus ?? this.radioStatus,
      selectedStation: selectedStation ?? this.selectedStation,
      selectedStationId: selectedStationId ?? this.selectedStationId,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
