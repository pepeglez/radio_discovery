import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:labhouse_radio_station/features/radio/data/datasources/radio_station_remote_datasource_impl.dart';
import 'package:labhouse_radio_station/features/radio/data/repositories/radio_station_repository_impl.dart';
import 'package:labhouse_radio_station/features/radio/domain/entities/radio_station.dart';
import 'package:labhouse_radio_station/features/radio/presentation/bloc/radio_station_cubit.dart';
import 'package:shimmer/shimmer.dart';

class RadioStationsPage extends StatelessWidget {
  const RadioStationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RadioStationCubit(
          RadioStationRepositoryImpl(RadioStationRemoteDatasourceImpl()))
        ..init(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Radio Stations'),
        ),
        body: BlocBuilder<RadioStationCubit, RadioStationState>(
          builder: (context, state) {
            switch (state.status) {
              case RadioStationPageStatus.loading:
                return _buildShimmeringList();
              case RadioStationPageStatus.success:
                return _buildRadioStationList(state.radioStations);
              case RadioStationPageStatus.error:
                return const Center(
                    child: Text(
                        'An error occurred while loading the radio stations.'));
              default:
                return Container();
            }
          },
        ),
      ),
    );
  }

  Widget _buildShimmeringList() {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: ListTile(
            leading: const CircleAvatar(backgroundColor: Colors.grey),
            title: Container(height: 10.0, color: Colors.white),
            subtitle: Container(height: 10.0, color: Colors.white),
          ),
        );
      },
    );
  }

  Widget _buildRadioStationList(List<RadioStation> radioStations) {
    return ListView.builder(
      itemCount: radioStations.length,
      itemBuilder: (context, index) {
        final radioStation = radioStations[index];
        return ListTile(
          leading: Image.network(
            radioStation.favicon.isNotEmpty
                ? radioStation.favicon
                : 'https://via.placeholder.com/150',
          ),
          title: Text(radioStation.name),
          subtitle: Text(radioStation.country),
        );
      },
    );
  }
}
