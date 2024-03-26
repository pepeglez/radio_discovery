import 'package:flutter/material.dart';
import 'package:radio_discovery/features/radio/domain/entities/radio_station.dart';
import 'package:radio_discovery/features/radio/presentation/widgets/station_card_widget.dart';

enum ListItemSize { small, large }

class StationHorizontalListWidget extends StatelessWidget {
  final String title;
  final ListItemSize listItemSize;
  final IconData icons;
  final List<RadioStation> radioStations;
  final Function(RadioStation) onRadioStationClicked;

  const StationHorizontalListWidget({
    super.key,
    required this.title,
    this.listItemSize = ListItemSize.small,
    required this.icons,
    required this.radioStations,
    required this.onRadioStationClicked,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.only(left: 24, top: 36),
          child: Row(
            children: [
              Icon(
                icons,
                size: 20,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(
                width: 8,
              ),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          height: listItemSize == ListItemSize.small ? 120 : 180,
          child: NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (OverscrollIndicatorNotification overscroll) {
              overscroll.disallowIndicator();
              return true;
            },
            child: ListView.builder(
                itemCount: radioStations.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: ((context, index) {
                  return GestureDetector(
                    onTap: () => onRadioStationClicked(radioStations[index]),
                    child:
                        StationCardWidget(radioStation: radioStations[index]),
                  );
                })),
          ),
        ),
      ],
    );
  }
}
