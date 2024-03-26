import 'package:flutter/material.dart';
import 'package:radio_discovery/features/radio/domain/entities/radio_station.dart';
import 'package:radio_discovery/features/radio/presentation/bloc/radio_payer_cubit.dart';
import 'package:radio_discovery/features/radio/presentation/helpers/radio_player_helper.dart';
import 'package:radio_discovery/features/radio/presentation/widgets/station_card_widget.dart';

class MiniRadioPlayerWidget extends StatelessWidget {
  final RadioStation radioStation;
  final RadioStatus radioStatus;
  final VoidCallback onPlayPause;

  const MiniRadioPlayerWidget({
    super.key,
    required this.radioStation,
    required this.radioStatus,
    required this.onPlayPause,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showRadioPlayer(context, radioStation, onPlayPause: onPlayPause);
      },
      child: Container(
        height: 64,
        padding: const EdgeInsets.all(4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            StationCardWidget(radioStation: radioStation),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                radioStation.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            )),
            IconButton(
              icon: radioStatus == RadioStatus.playing
                  ? const Icon(Icons.pause)
                  : const Icon(Icons.play_arrow),
              onPressed: onPlayPause,
            ),
          ],
        ),
      ),
    );
  }
}
