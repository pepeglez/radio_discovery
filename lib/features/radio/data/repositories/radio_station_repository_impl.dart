import 'package:dartz/dartz.dart';
import 'package:labhouse_radio_station/features/radio/data/datasources/radio_station_remote_datasource_impl.dart';
import 'package:labhouse_radio_station/features/radio/domain/entities/radio_station.dart';

class RadioStationRepositoryImpl implements RadioStationRepository {
  late RadioStationRemoteDatasource remoteDataSource;

  RadioStationRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<String, List<RadioStation>>> getRadioStations() async {
    
    final radioStations = await remoteDataSource.getRadioStations();
    return radioStations;
  }
}

abstract class RadioStationRepository {
  Future<Either<String, List<RadioStation>>> getRadioStations();
}
