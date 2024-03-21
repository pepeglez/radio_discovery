import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:labhouse_radio_station/features/radio/data/repositories/radio_station_repository_impl.dart';
import 'package:labhouse_radio_station/features/radio/data/services/just_audio_service.dart';
import 'package:labhouse_radio_station/features/radio/domain/entities/radio_station.dart';
import 'package:labhouse_radio_station/features/radio/domain/services/audio_service.dart';

enum RadioStationPageStatus { initial, loading, success, error }

enum RadioStatus { playing, paused }

class RadioStationCubit extends Cubit<RadioStationState> {
  final RadioStationRepository _repository;
  final AudioService _audioService = JustAudioService();

  RadioStationCubit(this._repository) : super(RadioStationState());

  Future<void> init() async {
    emit(state.copyWith(status: RadioStationPageStatus.loading));
    final radioStationsResult = await _repository.getRadioStations();
    radioStationsResult.fold(
      (failure) => emit(state.copyWith(status: RadioStationPageStatus.error)),
      (radioStations) => emit(state.copyWith(
          status: RadioStationPageStatus.success,
          radioStations: radioStations)),
    );
  }

  void playPauseRadioStation(int index) {
    if (state.radioStatus == RadioStatus.paused) {
      playRadioStation(index);
    } else {
      stopRadioStation();
    }
  }

  void playRadioStation(int index) {
    _audioService.startPlaying(state.radioStations[index].url);
    emit(state.copyWith(radioStatus: RadioStatus.playing));
  }

  void stopRadioStation() {
    _audioService.stopPlaying();
    emit(state.copyWith(radioStatus: RadioStatus.paused));
  }

  @override
  Future<void> close() {
    _audioService.dispose();
    return super.close();
  }
}

class RadioStationState extends Equatable {
  final RadioStationPageStatus status;
  final RadioStatus radioStatus;
  final List<RadioStation> radioStations;

  const RadioStationState({
    this.status = RadioStationPageStatus.initial,
    this.radioStatus = RadioStatus.paused,
    this.radioStations = const [],
  });

  @override
  List<Object?> get props => [status, radioStatus, radioStations];

  RadioStationState copyWith({
    RadioStationPageStatus? status,
    RadioStatus? radioStatus,
    List<RadioStation>? radioStations,
  }) {
    return RadioStationState(
      status: status ?? this.status,
      radioStatus: radioStatus ?? this.radioStatus,
      radioStations: radioStations ?? this.radioStations,
    );
  }
}
