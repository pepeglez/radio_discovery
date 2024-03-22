import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:labhouse_radio_station/core/presentation/app_theme.dart';
import 'package:labhouse_radio_station/features/radio/data/datasources/radio_station_remote_datasource_impl.dart';
import 'package:labhouse_radio_station/features/radio/data/repositories/radio_station_repository_impl.dart';
import 'package:labhouse_radio_station/features/radio/presentation/bloc/home_cubit.dart';
import 'package:labhouse_radio_station/features/radio/presentation/pages/home_page.dart';

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
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      home: BlocProvider(
        create: (context) => HomeCubit(
          RadioStationRepositoryImpl(RadioStationRemoteDatasourceImpl()),
        )..init(),
        child: const HomePage(),
      ),
    );
  }
}
