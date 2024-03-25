import 'package:flutter/material.dart';
import 'package:labhouse_radio_station/features/radio/domain/entities/radio_station.dart';

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

class TagsListWidget extends StatelessWidget {
  const TagsListWidget({
    super.key,
    required this.radioStation,
    this.centered = false,
  });

  final RadioStation radioStation;
  final bool centered;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 2,
      alignment: centered ? WrapAlignment.center : WrapAlignment.start,
      children: radioStation.tags.split(',').take(7).map((tag) {
        if (tag.isEmpty) return const SizedBox.shrink();
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text(
              tag.toUpperCase(),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        );
      }).toList(),
    );
  }
}
