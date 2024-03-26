import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:labhouse_radio_station/features/radio/data/repositories/radio_station_repository_impl.dart';
import 'package:labhouse_radio_station/features/radio/domain/entities/radio_station.dart';

enum HomePageStatus { initial, loading, success, error }

class HomeCubit extends Cubit<HomeState> {
  final RadioStationRepository _repository;
  StreamSubscription? _favoriteStationsSubscription;
  StreamSubscription? _recentStationsSubscription;

  HomeCubit(this._repository) : super(const HomeState());

  Future<void> init() async {
    emit(state.copyWith(status: HomePageStatus.initial));
    final radioStationsResult = await _repository.getRadioStations();
    radioStationsResult.fold(
      (failure) => emit(state.copyWith(status: HomePageStatus.error)),
      (radioStations) => emit(state.copyWith(
          status: HomePageStatus.success, radioStations: radioStations)),
    );

    _bindFavoriteStations();
    _bindRecentStations();
  }

  void _bindFavoriteStations() {
    unawaited(_repository.getFavoriteRadioStations());
    _favoriteStationsSubscription =
        _repository.favoriteRadioStationStream.listen((radioStations) {
      emit(state.copyWith(
          favoritesRadioStations: radioStations.values.toList()));
    });
  }

  void _bindRecentStations() {
    unawaited(_repository.getRecentRadioStations());
    _recentStationsSubscription =
        _repository.recentRadioStationStream.listen((radioStations) {
      emit(state.copyWith(recentRadioStations: radioStations.values.toList()));
    });
  }

  List<String> getGenreList() {
    return state.genres;
  }

  List<String> getCountryList() {
    return state.countries;
  }

  @override
  Future<void> close() {
    _favoriteStationsSubscription?.cancel();
    _recentStationsSubscription?.cancel();
    return super.close();
  }
}

class HomeState extends Equatable {
  final HomePageStatus status;
  final List<RadioStation> radioStations;
  final List<RadioStation> favoritesRadioStations;
  final List<RadioStation> recentRadioStations;
  final List<String> genres;
  final List<String> countries;

  const HomeState({
    this.status = HomePageStatus.initial,
    this.radioStations = const [],
    this.favoritesRadioStations = const [],
    this.recentRadioStations = const [],
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
  List<Object?> get props =>
      [status, radioStations, favoritesRadioStations, recentRadioStations];

  HomeState copyWith({
    HomePageStatus? status,
    List<RadioStation>? radioStations,
    List<RadioStation>? favoritesRadioStations,
    List<RadioStation>? recentRadioStations,
    List<String>? genres,
    List<String>? countries,
  }) {
    return HomeState(
      status: status ?? this.status,
      radioStations: radioStations ?? this.radioStations,
      genres: genres ?? this.genres,
      countries: countries ?? this.countries,
      favoritesRadioStations:
          favoritesRadioStations ?? this.favoritesRadioStations,
      recentRadioStations: recentRadioStations ?? this.recentRadioStations,
    );
  }
}
