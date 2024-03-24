import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:labhouse_radio_station/features/radio/data/datasources/radio_station_remote_datasource_impl.dart';
import 'package:labhouse_radio_station/features/radio/domain/entities/radio_station.dart';

class RadioStationRepositoryImpl implements RadioStationRepository {
  late RadioStationRemoteDatasource remoteDataSource;

  final Map<String, RadioStation> _radioStations = {};

  RadioStationRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<String, List<RadioStation>>> getRadioStations() async {
    final radioStations = await remoteDataSource.getRadioStations();
    
    radioStations.fold((failure) => failure, (radioStations) {
      unawaited(_storeRadioStations(radioStations));
    });

    return radioStations;
  }

  RadioStation getRadioStation(String id) {
    return _radioStations[id]!;
  }

  Future<void> _storeRadioStations(List<RadioStation> radioStations) async {
    for (var radioStation in radioStations) {
      _radioStations[radioStation.stationUuid] = radioStation;
    }
  }
}

abstract class RadioStationRepository {
  Future<Either<String, List<RadioStation>>> getRadioStations();
}
