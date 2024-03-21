import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:labhouse_radio_station/features/radio/domain/entities/radio_station.dart';

class RadioStationRemoteDatasourceImpl implements RadioStationRemoteDatasource {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'http://de1.api.radio-browser.info'));

  @override
  Future<Either<String, List<RadioStation>>> getRadioStations() async {
    try {
      final response = await _dio.get('/json/stations/byname/rock?limit=10');
      if (response.statusCode == 200) {
        debugPrint('Response: ${response.data}');
        final List<dynamic> list = response.data;
        final stations = list.map((json) => RadioStation.fromJson(json)).toList();
        return Right(stations);
      } else {
        debugPrint('Error: ${response.statusCode}');
        return Left('Error: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error: $e');
      return Left(e.toString());
    }
  }
}

abstract class RadioStationRemoteDatasource {
  Future<Either<String, List<RadioStation>>> getRadioStations();
}