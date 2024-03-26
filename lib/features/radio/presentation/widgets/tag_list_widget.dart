import 'package:flutter/material.dart';
import 'package:radio_discovery/features/radio/domain/entities/radio_station.dart';

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
