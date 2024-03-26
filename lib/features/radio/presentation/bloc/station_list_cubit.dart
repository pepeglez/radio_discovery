import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:radio_discovery/features/radio/data/repositories/radio_station_repository_impl.dart';
import 'package:radio_discovery/features/radio/domain/entities/radio_station.dart';

enum StationListPageStatus { initial, loading, success, error }

enum StationListType { genre, country }

class StationListCubit extends Cubit<StationListState> {
  final RadioStationRepository _repository;

  StationListCubit(this._repository) : super(const StationListState());

  Future<void> init(
      {required StationListType listType, required String query}) async {
    emit(state.copyWith(
        status: StationListPageStatus.loading,
        query: query,
        listType: listType));
    final Either<String, List<RadioStation>> radioStationsResult;

    switch (listType) {
      case StationListType.country:
        radioStationsResult =
            await _repository.getRadioStations(country: query);
        break;
      case StationListType.genre:
        radioStationsResult = await _repository.getRadioStations(tag: query);
        break;
    }

    radioStationsResult.fold(
      (failure) => emit(state.copyWith(status: StationListPageStatus.error)),
      (radioStations) => emit(state.copyWith(
          status: StationListPageStatus.success, radioStations: radioStations)),
    );
  }

  String get query => state.query;
}

class StationListState extends Equatable {
  final StationListPageStatus status;
  final StationListType listType;
  final String query;
  final List<RadioStation> radioStations;

  const StationListState({
    this.status = StationListPageStatus.initial,
    this.radioStations = const [],
    this.listType = StationListType.genre,
    this.query = '',
  });

  @override
  List<Object?> get props => [status, radioStations, listType, query];

  StationListState copyWith({
    StationListPageStatus? status,
    List<RadioStation>? radioStations,
    StationListType? listType,
    String? query,
  }) {
    return StationListState(
      status: status ?? this.status,
      radioStations: radioStations ?? this.radioStations,
      listType: listType ?? this.listType,
      query: query ?? this.query,
    );
  }
}
