import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:labhouse_radio_station/core/presentation/app_theme.dart';
import 'package:labhouse_radio_station/core/presentation/router/app_router.dart';
import 'package:labhouse_radio_station/features/radio/data/datasources/radio_station_local_datasource_impl.dart';
import 'package:labhouse_radio_station/features/radio/data/datasources/radio_station_remote_datasource_impl.dart';
import 'package:labhouse_radio_station/features/radio/data/repositories/radio_station_repository_impl.dart';
import 'package:labhouse_radio_station/features/radio/data/services/just_audio_service.dart';
import 'package:labhouse_radio_station/features/radio/domain/services/audio_service.dart';
import 'package:labhouse_radio_station/features/radio/presentation/bloc/radio_payer_cubit.dart';

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
        getIt(),
      )..init(),
      child: MaterialApp.router(
        title: 'Labhouse Radio Station',
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: ThemeMode.dark,
        routerConfig: MyAppRouter.router,
      ),
    );
  }
}

Future<void> injectDependencies() async {
  getIt.registerLazySingleton<RadioStationRemoteDatasource>(
      () => RadioStationRemoteDatasourceImpl());

  getIt.registerLazySingleton<RadioStationLocalDataSource>(() =>
      RadioStationLocalDataSourceImpl(
          secureStorage: const FlutterSecureStorage()));

  getIt.registerLazySingleton<AudioService>(() => JustAudioService());

  getIt.registerLazySingleton<RadioStationRepository>(
    () => RadioStationRepositoryImpl(
        remoteDataSource: getIt<RadioStationRemoteDatasource>(),
        localDataSource: getIt<RadioStationLocalDataSource>()),
  );
}
