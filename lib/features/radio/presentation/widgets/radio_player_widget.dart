import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:labhouse_radio_station/core/presentation/app_theme.dart';
import 'package:labhouse_radio_station/features/radio/domain/entities/radio_station.dart';
import 'package:labhouse_radio_station/features/radio/presentation/bloc/radio_payer_cubit.dart';
import 'package:lottie/lottie.dart';

class MediaPlayerWidget extends StatelessWidget {
  final RadioStation radioStation;
  final VoidCallback onPlayPause;
  final VoidCallback onNext;
  final VoidCallback onPrevious;

  const MediaPlayerWidget({
    super.key,
    required this.radioStation,
    required this.onPlayPause,
    required this.onNext,
    required this.onPrevious,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(radioStation.favicon),
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
          SafeArea(
            child: Column(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_downward_sharp),
                      onPressed: () {},
                    ),
                    const SizedBox(width: 16),
                    Text(
                      'Now playing',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ],
                ),
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Card(
                          elevation: 8,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(80),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(80),
                            child: Image.network(
                              radioStation.favicon.isNotEmpty
                                  ? radioStation.favicon
                                  : 'https://via.placeholder.com/150',
                              width: width * 0.8,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        Text(
                          radioStation.name,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        Text(
                          radioStation.country,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Text(
                          radioStation.language,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        //const SizedBox(height: 32),
                        SizedBox(
                          height: 100,
                          child: Center(
                            child:
                                BlocBuilder<RadioPlayerCubit, RadioPlayerState>(
                              builder: (context, state) {
                                switch (state.radioStatus) {
                                  case RadioStatus.paused:
                                  case RadioStatus.idle:
                                    return Container(
                                      height: 60,
                                    );
                                  case RadioStatus.loading:
                                    return Container(
                                      height: 40,
                                      width: 40,
                                      child: CircularProgressIndicator(),
                                    );
                                  case RadioStatus.playing:
                                    return Container(
                                      child: Lottie.asset(
                                        'assets/lottie/radio_wave.json',
                                        width: 200,
                                      ),
                                    );
                                  case RadioStatus.error:
                                    return const SizedBox(
                                      height: 60,
                                      child: Text('ERROR'),
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
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      PlayerIconButton(
                        icon: Icons.skip_previous_sharp,
                        onPressed: onPrevious,
                        size: PlayerButtonSize.small,
                      ),
                      const SizedBox(width: 16),
                      BlocBuilder<RadioPlayerCubit, RadioPlayerState>(
                        builder: (context, state) {
                          return PlayerIconButton(
                              icon: state.radioStatus == RadioStatus.playing
                                  ? Icons.pause
                                  : Icons.play_arrow,
                              onPressed: onPlayPause);
                        },
                      ),
                      const SizedBox(width: 16),
                      PlayerIconButton(
                        icon: Icons.skip_next_sharp,
                        onPressed: onNext,
                        size: PlayerButtonSize.small,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

enum PlayerButtonSize {
  small,
  big,
}

class PlayerIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final PlayerButtonSize size;

  const PlayerIconButton({
    super.key,
    this.icon = Icons.play_arrow,
    required this.onPressed,
    this.size = PlayerButtonSize.big,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5.0,
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: Ink(
        width: size == PlayerButtonSize.big ? 80 : 60,
        height: 80,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.black,
              (size == PlayerButtonSize.big ? Colors.blue : Colors.grey)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          shape: BoxShape.circle,
        ),
        child: InkWell(
          onTap: onPressed,
          child: Center(
            child: Icon(icon, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
