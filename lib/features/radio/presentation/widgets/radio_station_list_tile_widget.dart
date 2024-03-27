import 'package:flutter/material.dart';
import 'package:radio_discovery/features/radio/domain/entities/radio_station.dart';
import 'package:radio_discovery/features/radio/presentation/widgets/station_card_widget.dart';
import 'package:radio_discovery/features/radio/presentation/widgets/tag_list_widget.dart';

class RadioStationListTileWidget extends StatelessWidget {
  const RadioStationListTileWidget({
    super.key,
    required this.radioStation,
    required this.onPressed,
  });

  final RadioStation radioStation;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
              height: 100,
              child: StationCardWidget(radioStation: radioStation)),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  radioStation.name,
                  style: Theme.of(context).textTheme.titleSmall,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  '${radioStation.country} | ${radioStation.votes} votes | ${radioStation.bitrate} kbps',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 4),
                TagsListWidget(radioStation: radioStation),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
