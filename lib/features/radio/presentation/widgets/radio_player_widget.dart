import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:radio_discovery/core/constants/asset_paths.dart';
import 'package:radio_discovery/core/presentation/app_theme.dart';
import 'package:radio_discovery/features/radio/domain/entities/radio_station.dart';
import 'package:radio_discovery/features/radio/presentation/bloc/radio_payer_cubit.dart';
import 'package:radio_discovery/features/radio/presentation/widgets/player_icon_button_widget.dart';
import 'package:radio_discovery/features/radio/presentation/widgets/station_card_widget.dart';
import 'package:radio_discovery/features/radio/presentation/widgets/tag_list_widget.dart';
import 'package:lottie/lottie.dart';

class RadioPlayerWidget extends StatelessWidget {
  final RadioStation radioStation;
  final VoidCallback onPlayPause;
  final VoidCallback onNext;
  final VoidCallback onPrevious;

  const RadioPlayerWidget({
    super.key,
    required this.radioStation,
    required this.onPlayPause,
    required this.onNext,
    required this.onPrevious,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return BlocBuilder<RadioPlayerCubit, RadioPlayerState>(
      builder: (context, state) {
        return Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(state.selectedStation!.favicon),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Theme.of(context).radioPlayerGradient1,
                    Theme.of(context).radioPlayerGradient2,
                  ],
                ),
              ),
            ),
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(
                color: Colors.black.withOpacity(0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 60),
              child: Column(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        flex: 1,
                        child: IconButton(
                          icon: const Icon(Icons.arrow_downward_sharp),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                      Flexible(
                        flex: 5,
                        child: Text(
                          'Now playing',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: IconButton(
                          icon: state.isFavorite
                              ? const Icon(
                                  Icons.favorite,
                                  color: Colors.red,
                                )
                              : const Icon(Icons.favorite_border),
                          onPressed: () {
                            debugPrint('Favorite');
                            context.read<RadioPlayerCubit>().toggleFavorite();
                          },
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: width * 0.1),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            StationCardWidget(radioStation: state.selectedStation!),
                            const SizedBox(height: 32),
                            TagsListWidget(
                              radioStation: state.selectedStation!,
                              centered: true,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              state.selectedStation!.name,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            Text(
                              state.selectedStation!.country,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            SizedBox(
                              height: 100,
                              child: Center(
                                child: Builder(
                                  builder: (context) {
                                    switch (state.radioStatus) {
                                      case RadioStatus.paused:
                                      case RadioStatus.idle:
                                        return Container(
                                          height: 60,
                                        );
                                      case RadioStatus.loading:
                                        return const SizedBox(
                                          height: 40,
                                          width: 40,
                                          child: CircularProgressIndicator(),
                                        );
                                      case RadioStatus.playing:
                                        return Container(
                                          child: Lottie.asset(
                                            AssetImages.lottieAnimation,
                                            width: 200,
                                          ),
                                        );
                                      case RadioStatus.error:
                                        return SizedBox(
                                          height: 60,
                                          child: Column(
                                            children: [
                                              const Icon(
                                                Icons.error,
                                                color: Colors.red,
                                                size: 32,
                                              ),
                                              Text(
                                                'This station cannot be played.',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge,
                                              ),
                                            ],
                                          ),
                                        );
                                    }
                                  },
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        PlayerIconButton(
                          icon: Icons.skip_previous_sharp,
                          onPressed: () {
                            context.read<RadioPlayerCubit>().playRadomStation();
                          },
                          size: PlayerButtonSize.small,
                        ),
                        const SizedBox(width: 16),
                        PlayerIconButton(
                            icon: state.radioStatus == RadioStatus.playing
                                ? Icons.pause
                                : Icons.play_arrow,
                            onPressed: onPlayPause),
                        const SizedBox(width: 16),
                        PlayerIconButton(
                          icon: Icons.skip_next_sharp,
                          onPressed: () {
                            context.read<RadioPlayerCubit>().playRadomStation();
                          },
                          size: PlayerButtonSize.small,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
