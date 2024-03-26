import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:radio_discovery/core/presentation/app_theme.dart';
import 'package:radio_discovery/features/radio/domain/entities/radio_station.dart';
import 'package:radio_discovery/features/radio/presentation/bloc/radio_payer_cubit.dart';
import 'package:radio_discovery/features/radio/presentation/widgets/tag_list_widget.dart';
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
    return Stack(
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
        Padding(
          padding: EdgeInsets.only(top: 60),
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
                  //const SizedBox(width: 16),
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
                      icon: BlocBuilder<RadioPlayerCubit, RadioPlayerState>(
                        builder: (context, state) {
                          return state.isFavorite
                              ? const Icon(
                                  Icons.favorite,
                                  color: Colors.red,
                                )
                              : const Icon(Icons.favorite_border);
                        },
                      ),
                      onPressed: () {
                        debugPrint('Favorite');
                        context
                            .read<RadioPlayerCubit>()
                            .toggleFavorite(radioStation);
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
                        Card(
                          //margin: EdgeInsets.symmetric(horizontal: width * 0.1),
                          elevation: 8,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(80),
                          ),
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(80),
                              child: Image.network(
                                radioStation.favicon.isNotEmpty
                                    ? radioStation.favicon
                                    : 'https://via.placeholder.com/150',
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        TagsListWidget(
                          radioStation: radioStation,
                          centered: true,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          radioStation.name,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        Text(
                          radioStation.country,
                          style: Theme.of(context).textTheme.bodyLarge,
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
              (size == PlayerButtonSize.big
                  ? Theme.of(context).primaryColor
                  : Colors.grey)
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
