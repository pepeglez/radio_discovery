import 'package:flutter/material.dart';
import 'package:labhouse_radio_station/features/radio/domain/entities/radio_station.dart';
import 'package:labhouse_radio_station/features/radio/presentation/widgets/tag_list_widget.dart';

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
          Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10), // Adjust as needed
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10), // Adjust as needed
              child: Image.network(
                height: 80,
                width: 80,
                radioStation.favicon.isNotEmpty
                    ? radioStation.favicon
                    : 'https://via.placeholder.com/150',
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 20), // Adjust as needed
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


