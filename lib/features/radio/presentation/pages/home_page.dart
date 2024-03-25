import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:labhouse_radio_station/core/presentation/router/app_router.dart';
import 'package:labhouse_radio_station/core/presentation/widgets/my_flexible_app_bar.dart';
import 'package:labhouse_radio_station/features/radio/domain/entities/radio_station.dart';
import 'package:labhouse_radio_station/features/radio/presentation/bloc/home_cubit.dart';
import 'package:labhouse_radio_station/features/radio/presentation/bloc/radio_payer_cubit.dart';
import 'package:labhouse_radio_station/features/radio/presentation/helpers/radio_player_helper.dart';
import 'package:labhouse_radio_station/features/radio/presentation/widgets/by_country_widget.dart';
import 'package:labhouse_radio_station/features/radio/presentation/widgets/featured_stations_widget.dart';
import 'package:labhouse_radio_station/features/radio/presentation/widgets/genres_list_widget.dart';
import 'package:labhouse_radio_station/features/radio/presentation/widgets/recently_played_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        slivers: <Widget>[
          const MyFlexibleAppBar(
            leading: Icon(
              Icons.radio,
              color: Colors.white,
            ),
            title: 'Station discovery',
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              <Widget>[
                BlocBuilder<HomeCubit, HomeState>(
                  builder: (context, state) {
                    return HorizontalStationListWidget(
                      title: 'My favorites',
                      icons: Icons.favorite,
                      listItemSize: ListItemSize.small,
                      radioStations: state.favoritesRadioStations,
                      onRadioStationClicked: (radioStation) {
                        context
                            .read<RadioPlayerCubit>()
                            .playPauseRadioStation(radioStation);
                        showRadioPlayer(context, radioStation, onPlayPause: () {
                          context
                              .read<RadioPlayerCubit>()
                              .playPauseRadioStation(radioStation);
                        });
                      },
                    );
                  },
                ),
                BlocBuilder<HomeCubit, HomeState>(
                  builder: (context, state) {
                    return HorizontalStationListWidget(
                      title: 'Recently played',
                      icons: Icons.history,
                      listItemSize: ListItemSize.large,
                      radioStations: state.recentRadioStations,
                      onRadioStationClicked: (radioStation) {
                        context
                            .read<RadioPlayerCubit>()
                            .playPauseRadioStation(radioStation);
                        showRadioPlayer(context, radioStation, onPlayPause: () {
                          context
                              .read<RadioPlayerCubit>()
                              .playPauseRadioStation(radioStation);
                        });
                      },
                    );
                  },
                ),
                BlocBuilder<HomeCubit, HomeState>(
                  builder: (context, state) {
                    return HorizontalStationListWidget(
                      title: 'Featured stations',
                      icons: Icons.star,
                      listItemSize: ListItemSize.large,
                      radioStations: state.radioStations,
                      onRadioStationClicked: (radioStation) {
                        context
                            .read<RadioPlayerCubit>()
                            .playPauseRadioStation(radioStation);
                        showRadioPlayer(context, radioStation, onPlayPause: () {
                          context
                              .read<RadioPlayerCubit>()
                              .playPauseRadioStation(radioStation);
                        });
                      },
                    );
                  },
                ),
                const SizedBox(
                  height: 32,
                ),
                GenresListWidget(
                  genres: context.read<HomeCubit>().getGenreList(),
                  onGenreSelected: (genre) {
                    MyAppRouter.navigateTo('/stations/genre/$genre');
                    debugPrint('Genre selected: $genre');
                  },
                ),
                const SizedBox(
                  height: 32,
                ),
                ByCountryWidget(
                    countries: context.read<HomeCubit>().getCountryList(),
                    onCountryClicked: (s) {
                      debugPrint('Country clicked: $s');
                      MyAppRouter.navigateTo('/stations/country/$s');
                    }),
                const SizedBox(
                  height: 200,
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.shuffle),
      ),
    );
  }
}
