import 'package:flutter/material.dart';
import 'package:radio_discovery/features/radio/domain/entities/radio_station.dart';
import 'package:radio_discovery/features/radio/presentation/widgets/radio_player_widget.dart';

void showRadioPlayer(BuildContext myContext, RadioStation radioStation,
    {required VoidCallback onPlayPause}) {
  showModalBottomSheet(
    context: myContext,
    useRootNavigator: true,
    isScrollControlled: true,
    builder: (context) {
      return MediaPlayerWidget(
        radioStation: radioStation,
        onPlayPause: onPlayPause,
        onNext: () {
          // Handle next
        },
        onPrevious: () {
          // Handle previous
        },
      );
    },
  );
}
