import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:labhouse_radio_station/features/radio/data/datasources/radio_station_remote_datasource_impl.dart';
import 'package:labhouse_radio_station/features/radio/data/repositories/radio_station_repository_impl.dart';
import 'package:labhouse_radio_station/features/radio/presentation/bloc/radio_station_cubit.dart';
import 'package:labhouse_radio_station/features/radio/presentation/pages/radio_stations_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Labhouse Radio Station',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider(
        create: (context) => RadioStationCubit(
          RadioStationRepositoryImpl(RadioStationRemoteDatasourceImpl()),
        )..init(),
        child: RadioStationsPage(),
      ),
    );
  }
}
