import 'package:flutter/material.dart';
import 'package:labhouse_radio_station/features/radio/domain/entities/radio_station.dart';

class MediaPlayerWidget extends StatelessWidget {
  final RadioStation radioStation;
  final VoidCallback onPlayPause;
  final VoidCallback onNext;
  final VoidCallback onPrevious;

  MediaPlayerWidget({
    required this.radioStation,
    required this.onPlayPause,
    required this.onNext,
    required this.onPrevious,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(
          title: Text('Playing'),
          leading: IconButton(
            icon: Icon(Icons.arrow_downward),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.network(
                  radioStation.favicon.isNotEmpty
                      ? radioStation.favicon
                      : 'https://via.placeholder.com/150',
                ),
                Text(radioStation.name),
              ],
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(Icons.skip_previous),
              onPressed: onPrevious,
            ),
            IconButton(
              icon: Icon(Icons.play_arrow),
              onPressed: onPlayPause,
            ),
            IconButton(
              icon: Icon(Icons.skip_next),
              onPressed: onNext,
            ),
          ],
        ),
      ],
    );
  }
}