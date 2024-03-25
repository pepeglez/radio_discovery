import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:labhouse_radio_station/features/radio/domain/entities/radio_station.dart';

import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class RadioStationLocalDataSourceImpl implements RadioStationLocalDataSource {
  static const String _favoriteStationsKey = 'favoriteStations';
  static const String _recentStationsKey = 'recentStations';

  final FlutterSecureStorage secureStorage;

  RadioStationLocalDataSourceImpl({required this.secureStorage});

  @override
  Future<void> saveFavoriteStations(List<RadioStation> stations) async {
    final String jsonStations = jsonEncode(stations);
    try {
      await secureStorage.write(key: _favoriteStationsKey, value: jsonStations);
    } catch (e) {
      debugPrint('Error saving favorite stations: $e');
    }
  }

  @override
  Future<Either<String, List<RadioStation>>> getFavoriteStations() async {
    try {
      final String? jsonStations =
          await secureStorage.read(key: _favoriteStationsKey);

      if (jsonStations != null) {
        return Right((jsonDecode(jsonStations) as List)
            .map((item) => RadioStation.fromJson(item))
            .toList());
      } else {
        return const Left("_local_storage_error");
      }
    } catch (e) {
      debugPrint('Error getting favorite stations: $e');
      return Left(e.toString());
    }
  }

  @override
  Future<void> saveRecentStations(List<RadioStation> stations) async {
    final String jsonStations = jsonEncode(stations);
    try {
      await secureStorage.write(key: _recentStationsKey, value: jsonStations);
    } catch (e) {
      debugPrint('Error saving recent stations: $e');
    }
  }

  @override
  Future<Either<String, List<RadioStation>>> getRecentStations() async {
    try {
      final String? jsonStations =
          await secureStorage.read(key: _recentStationsKey);

      if (jsonStations != null) {
        return Right((jsonDecode(jsonStations) as List)
            .map((item) => RadioStation.fromJson(item))
            .toList());
      } else {
        return const Left("No recent stations found.");
      }
    } catch (e) {
      debugPrint('Error getting recent stations: $e');
      return Left(e.toString());
    }
  }

  @override
  Future<void> addFavoriteStation(RadioStation station) async {
    var favoriteStations = await getFavoriteStations();
    favoriteStations.fold((l) => [], (r) => r).add(station);
    await saveFavoriteStations(favoriteStations.fold((l) => [], (r) => r));
  }

  @override
  Future<void> removeFavoriteStation(RadioStation station) async {
    var favoriteStations = await getFavoriteStations();
    favoriteStations.fold((l) => [], (r) {
      r.removeWhere((item) => item.stationUuid == station.stationUuid);
      saveFavoriteStations(r);
    });
  }

  @override
  Future<void> addRecentStation(RadioStation station) async {
    List<RadioStation> recentStations = [];
    var recentStationsResult = await getRecentStations();
    recentStationsResult.fold((l) => [], (r) {
      recentStations = r;
    });
    recentStations.add(station);
    await saveRecentStations(recentStations);
  }

  @override
  Future<void> removeRecentStation(RadioStation station) async {
    var recentStationsResult = await getRecentStations();
    recentStationsResult.fold((l) => [], (r) {
      r.removeWhere((item) => item.stationUuid == station.stationUuid);
      saveRecentStations(r);
    });
  }
}

abstract class RadioStationLocalDataSource {
  Future<void> saveFavoriteStations(List<RadioStation> stations);
  Future<Either<String, List<RadioStation>>> getFavoriteStations();

  Future<void> saveRecentStations(List<RadioStation> stations);
  Future<Either<String, List<RadioStation>>> getRecentStations();

  Future<void> addFavoriteStation(RadioStation station);
  Future<void> removeFavoriteStation(RadioStation station);
  Future<void> addRecentStation(RadioStation station);
  Future<void> removeRecentStation(RadioStation station);
}
