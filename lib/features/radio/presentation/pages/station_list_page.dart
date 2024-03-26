import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:radio_discovery/core/presentation/app_theme.dart';
import 'package:radio_discovery/core/presentation/widgets/my_flexible_app_bar.dart';
import 'package:radio_discovery/features/radio/domain/entities/radio_station.dart';
import 'package:radio_discovery/features/radio/presentation/bloc/radio_payer_cubit.dart';
import 'package:radio_discovery/features/radio/presentation/bloc/station_list_cubit.dart';
import 'package:radio_discovery/features/radio/presentation/helpers/radio_player_helper.dart';
import 'package:radio_discovery/features/radio/presentation/widgets/mini_radio_player_widget.dart';
import 'package:radio_discovery/features/radio/presentation/widgets/radio_station_list_tile_widget.dart';
import 'package:shimmer/shimmer.dart';

class StationListPage extends StatelessWidget {
  const StationListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StationListCubit, StationListState>(
      builder: (context, state) {
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
              MyFlexibleAppBar(
                title: '# ${state.query}',
                leading: IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
              if (state.status == StationListPageStatus.loading)
                _buildShimmeringList(),
              if (state.status == StationListPageStatus.success)
                _buildRadioStationList(state.radioStations, context),
              if (state.status == StationListPageStatus.error)
                _buildErrorList(context),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {},
            child: const Icon(Icons.shuffle),
          ),
        );
      },
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
        childCount: 10, // Adjust as needed
      ),
    );
  }

  Widget _buildRadioStationList(
      List<RadioStation> radioStations, BuildContext myContext) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          final radioStation = radioStations[index];
          return Padding(
            padding: EdgeInsets.only(
                top: (index == 0) ? 32.0 : 12.0,
                bottom: 12.0,
                left: 20,
                right: 20),
            child: RadioStationListTileWidget(
              radioStation: radioStation,
              onPressed: () {
                context
                    .read<RadioPlayerCubit>()
                    .playPauseRadioStation(radioStation);
                showRadioPlayer(myContext, radioStation, onPlayPause: () {
                  context
                      .read<RadioPlayerCubit>()
                      .playPauseRadioStation(radioStation);
                });
              },
            ),
          );
        },
        childCount: radioStations.length,
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
                  padding: const EdgeInsets.only(top: 16),
                  child: Text(
                    'An error occurred!',
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
