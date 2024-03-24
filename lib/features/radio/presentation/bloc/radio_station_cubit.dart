import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:labhouse_radio_station/features/radio/data/repositories/radio_station_repository_impl.dart';
import 'package:labhouse_radio_station/features/radio/domain/entities/radio_station.dart';

enum RadioStationPageStatus { initial, loading, success, error }

class RadioStationCubit extends Cubit<RadioStationState> {
  final RadioStationRepository _repository;

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
}

class RadioStationState extends Equatable {
  final RadioStationPageStatus status;
  final List<RadioStation> radioStations;

  const RadioStationState({
    this.status = RadioStationPageStatus.initial,
    this.radioStations = const [],
  });

  @override
  List<Object?> get props => [status, radioStations];

  RadioStationState copyWith({
    RadioStationPageStatus? status,
    List<RadioStation>? radioStations,
  }) {
    return RadioStationState(
      status: status ?? this.status,
      radioStations: radioStations ?? this.radioStations,
    );
  }
}
