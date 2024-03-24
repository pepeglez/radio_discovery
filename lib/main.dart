import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:labhouse_radio_station/core/presentation/app_theme.dart';
import 'package:labhouse_radio_station/features/radio/data/datasources/radio_station_remote_datasource_impl.dart';
import 'package:labhouse_radio_station/features/radio/data/repositories/radio_station_repository_impl.dart';
import 'package:labhouse_radio_station/features/radio/data/services/just_audio_service.dart';
import 'package:labhouse_radio_station/features/radio/domain/services/audio_service.dart';
import 'package:labhouse_radio_station/features/radio/presentation/bloc/home_cubit.dart';
import 'package:labhouse_radio_station/features/radio/presentation/bloc/radio_payer_cubit.dart';
import 'package:labhouse_radio_station/features/radio/presentation/pages/home_page.dart';

GetIt getIt = GetIt.instance;

void main() async {
  await injectDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RadioPlayerCubit(
        getIt(),
      )..init(),
      child: MaterialApp(
        title: 'Labhouse Radio Station',
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: ThemeMode.system,
        home: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => HomeCubit(getIt())..init(),
            ),
          ],
          child: const HomePage(),
        ),
      ),
    );
  }
}

Future<void> injectDependencies() async {
  getIt.registerLazySingleton<RadioStationRemoteDatasource>(
      () => RadioStationRemoteDatasourceImpl());

  getIt.registerLazySingleton<AudioService>(() => JustAudioService());

  getIt.registerLazySingleton<RadioStationRepository>(
    () => RadioStationRepositoryImpl(
        remoteDataSource: getIt<RadioStationRemoteDatasource>()),
  );
}
