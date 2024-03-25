import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:labhouse_radio_station/features/radio/data/datasources/radio_station_local_datasource_impl.dart';
import 'package:labhouse_radio_station/features/radio/data/datasources/radio_station_remote_datasource_impl.dart';
import 'package:labhouse_radio_station/features/radio/domain/entities/radio_station.dart';

class RadioStationRepositoryImpl implements RadioStationRepository {
  late RadioStationRemoteDatasource remoteDataSource;
  late RadioStationLocalDataSource localDataSource;

  final Map<String, RadioStation> _radioStations = {};
  final Map<String, RadioStation> _favoritesRadioStations = {};
  final Map<String, RadioStation> _recentRadioStations = {};

  final StreamController<Map<String, RadioStation>>
      _favoritesRadioStationStreamController =
      StreamController<Map<String, RadioStation>>();

  @override
  Stream<Map<String, RadioStation>> get favoriteRadioStationStream =>
      _favoritesRadioStationStreamController.stream;

  final StreamController<Map<String, RadioStation>>
      _recentRadioStationStreamController =
      StreamController<Map<String, RadioStation>>();

  @override
  Stream<Map<String, RadioStation>> get recentRadioStationStream =>
      _recentRadioStationStreamController.stream;

  RadioStationRepositoryImpl(
      {required this.remoteDataSource, required this.localDataSource});

  @override
  Future<Either<String, List<RadioStation>>> getRadioStations(
      {String? tag, String? country}) async {
    final Either<String, List<RadioStation>> radioStations;

    if (tag != null) {
      radioStations = await remoteDataSource.getRadioStationsByTag(tag);
    } else if (country != null) {
      radioStations = await remoteDataSource.getRadioStationsByCountry(country);
    } else {
      radioStations = await remoteDataSource.getRadioStations();
    }

    radioStations.fold((failure) => failure, (radioStations) {
      unawaited(_storeRadioStations(radioStations));
    });

    return radioStations;
  }

  Future<void> _storeRadioStations(List<RadioStation> radioStations) async {
    for (var radioStation in radioStations) {
      _radioStations[radioStation.stationUuid] = radioStation;
    }
  }

  @override
  Future<Either<String, List<RadioStation>>> getFavoriteRadioStations() async {
    var favoriteRadioStationsResult =
        await localDataSource.getFavoriteStations();

    favoriteRadioStationsResult.fold(
        (failure) => failure,
        (radioStations) => radioStations.forEach((radioStation) {
              _favoritesRadioStations[radioStation.stationUuid] = radioStation;
            }));

    _favoritesRadioStationStreamController.add(_favoritesRadioStations);

    return favoriteRadioStationsResult;
  }

  @override
  Future<Either<String, List<RadioStation>>> getRecentRadioStations() async {
    var recentRadioStationsResult = await localDataSource.getRecentStations();

    recentRadioStationsResult.fold(
        (failure) => failure,
        (radioStations) => radioStations.forEach((radioStation) {
              _recentRadioStations[radioStation.stationUuid] = radioStation;
            }));

    _recentRadioStationStreamController.add(_recentRadioStations);

    return recentRadioStationsResult;
  }

  RadioStation getRadioStation(String id) {
    return _radioStations[id]!;
  }

  @override
  Future<void> toggleFavoriteRadioStation(RadioStation radioStation) async {
    if (_favoritesRadioStations.containsKey(radioStation.stationUuid)) {
      _favoritesRadioStations.remove(radioStation.stationUuid);
      _favoritesRadioStationStreamController.add(_favoritesRadioStations);
      await localDataSource.removeFavoriteStation(radioStation);
    } else {
      _favoritesRadioStations[radioStation.stationUuid] = radioStation;
      _favoritesRadioStationStreamController.add(_favoritesRadioStations);
      await localDataSource.addFavoriteStation(radioStation);
    }
  }

  @override
  Future<bool> isFavorite(RadioStation radioStation) async {
    return _favoritesRadioStations.containsKey(radioStation.stationUuid);
  }

  @override
  Future<void> addRecentStation(RadioStation radioStation) async {
    if (_recentRadioStations.containsKey(radioStation.stationUuid)) {
      return;
    }

    _recentRadioStations[radioStation.stationUuid] = radioStation;
    _recentRadioStationStreamController.add(_recentRadioStations);

    unawaited(localDataSource.addRecentStation(radioStation));
  }
}

abstract class RadioStationRepository {
  Future<Either<String, List<RadioStation>>> getRadioStations(
      {String? tag, String? country});
  Future<void> toggleFavoriteRadioStation(RadioStation radioStation);
  Future<void> addRecentStation(RadioStation radioStation);
  Future<Either<String, List<RadioStation>>> getRecentRadioStations();
  Future<Either<String, List<RadioStation>>> getFavoriteRadioStations();
  Future<bool> isFavorite(RadioStation radioStation);
  Stream<Map<String, RadioStation>> get favoriteRadioStationStream;
  Stream<Map<String, RadioStation>> get recentRadioStationStream;
}
