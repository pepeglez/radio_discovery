import 'package:flutter/material.dart';
import 'package:labhouse_radio_station/features/radio/domain/entities/radio_station.dart';

enum ListItemSize { small, large }

class HorizontalStationListWidget extends StatelessWidget {
  final String title;
  final ListItemSize listItemSize;
  final IconData icons;
  final List<RadioStation> radioStations;
  final Function(RadioStation) onRadioStationClicked;

  const HorizontalStationListWidget({
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
              Icon(icons, size: 20, color: Theme.of(context).primaryColor,),
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
                    child: Card(
                      margin: const  EdgeInsets.all(8),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      elevation: 4,
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.network(
                            radioStations[index].favicon.isNotEmpty
                                ? radioStations[index].favicon
                                : 'https://via.placeholder.com/150',
                          ),
                        ),
                      ),
                    ),
                  );
                })),
          ),
        ),
      ],
    );
  }
}
