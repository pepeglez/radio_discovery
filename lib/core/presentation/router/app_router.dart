import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:labhouse_radio_station/features/radio/presentation/bloc/home_cubit.dart';
import 'package:labhouse_radio_station/features/radio/presentation/bloc/station_list_cubit.dart';
import 'package:labhouse_radio_station/features/radio/presentation/pages/home_page.dart';
import 'package:labhouse_radio_station/features/radio/presentation/pages/station_list_page.dart';
import 'package:labhouse_radio_station/main.dart';

class MyAppRouter {
  static const String root = '/';
  static const String stations = '/stations';

  static final router = GoRouter(
    routes: <RouteBase>[
      GoRoute(
          path: '/',
          builder: (context, state) {
            return BlocProvider(
              create: (context) => HomeCubit(getIt())..init(),
              child: const HomePage(),
            );
          },
          routes: [
            GoRoute(
              path: 'stations/:type/:query',
              builder: (context, state) {
                final query = state.pathParameters['query'];
                final type = state.pathParameters['type'];
                debugPrint('Type: $type / Query: $query');
                return BlocProvider(
                  create: (context) => StationListCubit(getIt())
                    ..init(
                        listType: type == 'genre'
                            ? StationListType.genre
                            : StationListType.country,
                        query: query ?? ''),
                  child: const StationListPage(),
                );
              },
            ),
          ]),
    ],
    errorPageBuilder: (context, state) => MaterialPage<void>(
      child: Scaffold(
        body: Center(
          child: Text(
            'Route not found: ${state.error}',
            style: const TextStyle(fontSize: 24),
          ),
        ),
      ),
    ),
  );

  static Future<void> navigateTo(String route) async {
    router.go(route);
  }
}
