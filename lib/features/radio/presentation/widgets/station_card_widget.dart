import 'package:flutter/material.dart';
import 'package:radio_discovery/features/radio/domain/entities/radio_station.dart';

class StationCardWidget extends StatelessWidget {
  const StationCardWidget({
    super.key,
    required this.radioStation,
  });

  final RadioStation radioStation;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: AspectRatio(
        aspectRatio: 1,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.network(
            radioStation.favicon.isNotEmpty
                ? radioStation.favicon
                : 'https://via.placeholder.com/150',
            fit: BoxFit.fitWidth,
          ),
        ),
      ),
    );
  }
}
