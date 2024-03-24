import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:labhouse_radio_station/features/radio/data/repositories/radio_station_repository_impl.dart';
import 'package:labhouse_radio_station/features/radio/domain/entities/radio_station.dart';

enum HomePageStatus { initial, loading, success, error }

enum RadioStatus { playing, paused }

class HomeCubit extends Cubit<HomeState> {
  final RadioStationRepository _repository;

  HomeCubit(this._repository) : super(const HomeState());

  Future<void> init() async {
    emit(state.copyWith(status: HomePageStatus.initial));
    final radioStationsResult = await _repository.getRadioStations();
    radioStationsResult.fold(
      (failure) => emit(state.copyWith(status: HomePageStatus.error)),
      (radioStations) => emit(state.copyWith(
          status: HomePageStatus.success, radioStations: radioStations)),
    );
  }

  List<String> getGenreList() {
    return state.genres;
  }

  List<String> getCountryList() {
    return state.countries;
  }

  @override
  Future<void> close() {
    return super.close();
  }
}

class HomeState extends Equatable {
  final HomePageStatus status;
  final RadioStatus radioStatus;
  final List<RadioStation> radioStations;
  final List<String> genres;
  final List<String> countries;

  const HomeState({
    this.status = HomePageStatus.initial,
    this.radioStatus = RadioStatus.paused,
    this.radioStations = const [],
    this.genres = const [
      'rock',
      'pop',
      'jazz',
      'classical',
      'hip hop',
      'rap',
      'country',
      'blues',
      'reggae',
      'metal'
    ],
    this.countries = const [
      'Spain',
      'France',
      'Italy',
      'China',
      'United States',
      'Cuba',
    ],
  });

  @override
  List<Object?> get props => [status, radioStatus, radioStations];

  HomeState copyWith({
    HomePageStatus? status,
    RadioStatus? radioStatus,
    List<RadioStation>? radioStations,
    List<String>? genres,
    List<String>? countries,
  }) {
    return HomeState(
      status: status ?? this.status,
      radioStatus: radioStatus ?? this.radioStatus,
      radioStations: radioStations ?? this.radioStations,
      genres: genres ?? this.genres,
      countries: countries ?? this.countries,
    );
  }
}
