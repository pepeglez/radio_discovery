import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:labhouse_radio_station/features/radio/domain/entities/radio_station.dart';
import 'package:labhouse_radio_station/features/radio/presentation/bloc/home_cubit.dart';
import 'package:labhouse_radio_station/features/radio/presentation/bloc/radio_station_cubit.dart';
import 'package:labhouse_radio_station/features/radio/presentation/widgets/by_country_widget.dart';
import 'package:labhouse_radio_station/features/radio/presentation/widgets/featured_stations_widget.dart';
import 'package:labhouse_radio_station/features/radio/presentation/widgets/genres_list_widget.dart';
import 'package:labhouse_radio_station/features/radio/presentation/widgets/radio_player_widget.dart';
import 'package:labhouse_radio_station/features/radio/presentation/widgets/recently_played_widget.dart';
import 'package:shimmer/shimmer.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        slivers: <Widget>[
          SliverAppBar(
            stretch: true,
            leading: const Icon(Icons.radio),
            elevation: 4,
            onStretchTrigger: () {
              // Function callback for stretch
              return Future<void>.value();
            },
            expandedHeight: 200.0,
            //pinned: true,
            shape: const ContinuousRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(50),
                bottomRight: Radius.circular(50),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: const <StretchMode>[
                StretchMode.zoomBackground,
                StretchMode.blurBackground,
                StretchMode.fadeTitle,
              ],
              centerTitle: false,

              //title: const Text('Station discovery'),
              background: ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    Image.network(
                      'https://howtostartanllc.com/images/business-ideas/business-idea-images/radio-station.jpg',
                      fit: BoxFit.cover,
                      alignment: Alignment.centerLeft,
                    ),
                    const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment(0.0, 0.5),
                          end: Alignment.center,
                          colors: <Color>[
                            Color(0x60000000),
                            Color(0x00000000),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              <Widget>[
                BlocBuilder<HomeCubit, HomeState>(
                  builder: (context, state) {
                    return RecentlyPlayedWidget(
                      radioStations: state.radioStations,
                      onRadioStationClicked: (radioStation) {
                        showRadioPlayer(context, radioStation, () {
                          context.read<HomeCubit>().playPauseRadioStation(
                              state.radioStations.indexOf(radioStation));
                        });
                      },
                    );
                  },
                ),
                const SizedBox(
                  height: 32,
                ),
                Container(
                  padding: const EdgeInsets.only(left: 24, top: 12),
                  child: Text(
                    'Genres',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
                GenresListWidget(
                  genres: context.read<HomeCubit>().getGenreList(),
                  onGenreSelected: (genre) {
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
                    }),
                const SizedBox(
                  height: 32,
                ),
                BlocBuilder<HomeCubit, HomeState>(
                  builder: (context, state) {
                    return FeaturedStationsWidget(
                      radioStations: state.radioStations,
                      onRadioStationClicked: (radioStation) {
                        showRadioPlayer(context, radioStation, () {
                          context.read<HomeCubit>().playPauseRadioStation(
                              state.radioStations.indexOf(radioStation));
                        });
                      },
                    );
                  },
                ),
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

  void showRadioPlayer(BuildContext myContext, RadioStation radioStation,
      VoidCallback onPlayPause) {
    showModalBottomSheet(
      context: myContext,
      useRootNavigator: true,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          height: MediaQuery.of(myContext).size.height * 0.8,
          child: MediaPlayerWidget(
            radioStation: radioStation,
            onPlayPause: onPlayPause,
            onNext: () {
              // Handle next
            },
            onPrevious: () {
              // Handle previous
            },
          ),
        );
      },
    );
  }
}
