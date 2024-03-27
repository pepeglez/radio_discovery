import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:radio_discovery/core/presentation/app_theme.dart';
import 'package:radio_discovery/core/presentation/router/app_router.dart';
import 'package:radio_discovery/core/presentation/widgets/my_flexible_app_bar.dart';
import 'package:radio_discovery/core/presentation/widgets/my_floating_action_button.dart';
import 'package:radio_discovery/features/radio/presentation/bloc/home_cubit.dart';
import 'package:radio_discovery/features/radio/presentation/bloc/radio_payer_cubit.dart';
import 'package:radio_discovery/features/radio/presentation/helpers/radio_player_helper.dart';
import 'package:radio_discovery/features/radio/presentation/widgets/by_country_widget.dart';
import 'package:radio_discovery/features/radio/presentation/widgets/genres_list_widget.dart';
import 'package:radio_discovery/features/radio/presentation/widgets/mini_radio_player_widget.dart';
import 'package:radio_discovery/features/radio/presentation/widgets/station_horizontal_list_widget.dart';
import 'package:shimmer/shimmer.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BlocBuilder<RadioPlayerCubit, RadioPlayerState>(
        builder: (context, state) {
          return state.selectedStation != null
              ? MiniRadioPlayerWidget(
                  radioStation: state.selectedStation!,
                  radioStatus: state.radioStatus,
                  onPlayPause: () {
                    context
                        .read<RadioPlayerCubit>()
                        .playPauseRadioStation(state.selectedStation!);
                  },
                )
              : const SizedBox.shrink();
        },
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        slivers: <Widget>[
          const MyFlexibleAppBar(
            leading: Icon(
              Icons.radio,
              color: Colors.white,
            ),
            title: 'Radio Discovery',
          ),
          BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) {
              switch (state.status) {
                case HomePageStatus.error:
                  return _buildErrorList(context);
                case HomePageStatus.loading:
                  return _buildShimmeringList();
                default:
                  return SliverList(
                    delegate: SliverChildListDelegate(
                      <Widget>[
                        if (state.favoritesRadioStations.isNotEmpty)
                          StationHorizontalListWidget(
                            title: 'My favorites',
                            icons: Icons.favorite,
                            listItemSize: ListItemSize.small,
                            radioStations: state.favoritesRadioStations,
                            onRadioStationClicked: (radioStation) {
                              context
                                  .read<RadioPlayerCubit>()
                                  .playPauseRadioStation(radioStation);
                              showRadioPlayer(context, radioStation,
                                  onPlayPause: () {
                                context
                                    .read<RadioPlayerCubit>()
                                    .playPauseRadioStation(radioStation);
                              });
                            },
                          ),
                        if (state.recentRadioStations.isNotEmpty)
                          StationHorizontalListWidget(
                            title: 'Recently played',
                            icons: Icons.history,
                            listItemSize: ListItemSize.large,
                            radioStations: state.recentRadioStations,
                            onRadioStationClicked: (radioStation) {
                              context
                                  .read<RadioPlayerCubit>()
                                  .playPauseRadioStation(radioStation);
                              showRadioPlayer(context, radioStation,
                                  onPlayPause: () {
                                context
                                    .read<RadioPlayerCubit>()
                                    .playPauseRadioStation(radioStation);
                              });
                            },
                          ),
                        StationHorizontalListWidget(
                          title: 'Featured stations',
                          icons: Icons.star,
                          listItemSize: ListItemSize.large,
                          radioStations: state.radioStations,
                          onRadioStationClicked: (radioStation) {
                            context
                                .read<RadioPlayerCubit>()
                                .playPauseRadioStation(radioStation);
                            showRadioPlayer(context, radioStation,
                                onPlayPause: () {
                              context
                                  .read<RadioPlayerCubit>()
                                  .playPauseRadioStation(radioStation);
                            });
                          },
                        ),
                        const SizedBox(
                          height: 32,
                        ),
                        GenresListWidget(
                          genres: context.read<HomeCubit>().getGenreList(),
                          onGenreSelected: (genre) {
                            MyAppRouter.navigateTo('/stations/genre/$genre');
                          },
                        ),
                        const SizedBox(
                          height: 32,
                        ),
                        ByCountryWidget(
                            countries:
                                context.read<HomeCubit>().getCountryList(),
                            onCountryClicked: (country) {
                              MyAppRouter.navigateTo(
                                  '/stations/country/$country');
                            }),
                        const SizedBox(
                          height: 200,
                        ),
                      ],
                    ),
                  );
              }
            },
          ),
        ],
      ),
      floatingActionButton: MyFloatingActionButton(
        onPressed: () {
          context.read<RadioPlayerCubit>().playRadomStation();
        },
      ),
    );
  }

  Widget _buildShimmeringList() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return Shimmer.fromColors(
            baseColor: Theme.of(context).shimmerBaseColor,
            highlightColor: Theme.of(context).shimmerHightlightColor,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                children: [
                  Container(
                    height: 100.0,
                    width: 100.0,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 180,
                        height: 10.0,
                        color: Colors.white,
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Container(
                        width: 180,
                        height: 10.0,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
        childCount: 10,
      ),
    );
  }

  Widget _buildErrorList(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate(
        [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                const SizedBox(height: 200.0),
                const Icon(
                  Icons.error,
                  color: Colors.red,
                  size: 60.0,
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'An error occurred ! \n Please check your internet connection and try again.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
